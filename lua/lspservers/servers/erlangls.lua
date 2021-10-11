local server = require 'lspservers/server'

return server.new {
  name = 'erlangls',
  cmd = { './bin/erlang_ls' },
  installer = [[
  set -e
  git clone --depth=1 https://github.com/erlang-ls/erlang_ls
  cd erlang_ls
  make
  cd ..
  mkdir ./bin
  cp ./erlang_ls/_build/default/bin/erlang_ls ./bin/erlang_ls
  chmod +x ./bin/erlang_ls
  ]],
}
