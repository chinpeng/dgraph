#!/bin/bash

VERSIONS_ARRAY=(
  'v0.9.0'
  'master'
  'v0.8.3'
)

joinVersions() {
	versions=$(printf ",%s" "${VERSIONS_ARRAY[@]}")
	echo ${versions:1}
}

VERSION_STRING=$(joinVersions)

run() {
  export CURRENT_BRANCH="master"
  export CURRENT_VERSION=${VERSIONS_ARRAY[0]}
  export VERSIONS=${VERSION_STRING}


  HUGO_TITLE="Dgraph Doc - local" \
  VERSIONS=${VERSION_STRING} \
  CURRENT_BRANCH="master" \
  pushd $GOPATH/src/github.com/dgraph-io/dgraph/wiki
  CURRENT_VERSION=${CURRENT_VERSION} hugo server -w
  popd
}

run
