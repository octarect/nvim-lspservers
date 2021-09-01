local server = require 'lspservers/server'

return server.new {
  name = 'tsserver',
  cmd = { './node_modules/.bin/typescript-language-server', '--stdio' },
  installer = [[
    set -e
    npm install typescript typescript-language-server
  ]],
}
