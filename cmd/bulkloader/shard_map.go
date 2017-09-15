package main

import "sync"

type shardMap struct {
	sync.RWMutex
	numShards   int
	predToShard map[string]int
	nextShard   int
}

func newShardMap(numShards int) *shardMap {
	return &shardMap{
		numShards:   numShards,
		predToShard: make(map[string]int),
	}
}

func (m *shardMap) shardFor(pred string) int {
	m.RLock()
	shard, ok := m.predToShard[pred]
	if ok {
		m.RUnlock()
		return shard
	}
	m.RUnlock()

	m.Lock()
	defer m.Unlock()
	shard, ok = m.predToShard[pred]
	if ok {
		return shard
	}

	shard = m.nextShard
	m.nextShard = (m.nextShard + 1) % m.numShards
	m.predToShard[pred] = shard
	return shard
}
