local server = require 'lspservers/server'

return server.new {
  name = 'jsonls',
  cmd = { './node_modules/.bin/vscode-json-language-server', '--stdio' },
  installer = [[
    set -e
    npm install vscode-langservers-extracted
  ]],
}
