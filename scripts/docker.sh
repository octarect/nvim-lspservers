#!/bin/bash

WORKING_DIR=/opt/nvim-lspservers
IMAGE_NAME=ghcr.io/octarect/nvim-lspservers:latest

root_dir="$(cd $(dirname ${BASH_SOURCE:-$0})/.. && pwd)"

opts="--rm"
while true; do
  if [[ ! "$1" =~ ^- ]]; then
    break
  fi
  opts="$opts $1"
  shift
done

docker container run $opts \
  -v $root_dir:$WORKING_DIR \
  -w $WORKING_DIR \
  $IMAGE_NAME \
  "$@"
