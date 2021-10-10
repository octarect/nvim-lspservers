local server = require 'lspservers/server'

return server.new {
  name = 'elixirls',
  cmd = { './language_server.sh' },
  installer = [[
  set -e
  curl -fLO https://github.com/elixir-lsp/elixir-ls/releases/latest/download/elixir-ls.zip
  unzip elixir-ls.zip
  chmod +x language_server.sh
  ]],
}
