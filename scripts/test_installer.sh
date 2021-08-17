#!/bin/bash

set -e

target_server="${1:-vimls}"

root_dir="$(cd $(dirname ${BASH_SOURCE:-$0})/.. && pwd)"

nvim_exec() {
    nvim --headless -u $root_dir/tests/minimal_init.vim -c "$1" -c q 2>&1
}

contains() {
    list="$1"
    value="$2"
    printf '%s\n' $list | grep -qx "$value" 2>&1 >/dev/null
}

servers=("$(nvim_exec "echo join(keys(luaeval(\"require('lspservers/alias').available()\")), ' ')")")

if ! contains "$servers" "$target_server"; then
    echo 'the server you specified cannot be found.'
    exit 1
fi

installation_path="/opt/test/$target_server"
script_path="$installation_path/install.sh"

script="$(nvim_exec "echo v:lua.require('lspservers/servers').$target_server.installer")"
cmd="$(nvim_exec "echo v:lua.require('lspservers/servers').$target_server.cmd[0]")"

if [ -d $installation_path ]; then
    rm -rf $installation_path
fi
mkdir -p $installation_path
cd $installation_path

touch $script_path
chmod 755 $script_path
echo "#!/bin/bash" >> $script_path
echo "$script" | awk '$1=$1 { gsub("\r", ""); print $0; }' >> $script_path

echo "Executing $script_path..."
$script_path
echo "Check whether language server is successfully installed or not"
if [ -f "$cmd" ]; then
    echo "OK"
    exit 0
else
    echo "NG"
    exit 1
fi

