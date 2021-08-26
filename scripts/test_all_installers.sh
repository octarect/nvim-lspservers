#!/bin/bash

set -e

root_dir="$(cd $(dirname ${BASH_SOURCE:-$0})/.. && pwd)"

nvim_exec() {
  nvim --headless -u $root_dir/tests/minimal_init.vim -c "$1" -c q 2>&1
}

servers=("$(nvim_exec "echo join(keys(luaeval(\"require('lspservers/alias').available()\")), ' ')")")

for server in $servers; do
  echo "- - - - - - - - - -"
  bash $root_dir/scripts/test_installer.sh $server
done
