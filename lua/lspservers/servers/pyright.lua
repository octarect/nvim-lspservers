local server = require 'lspservers/server'

return server.new {
  name = 'pyright',
  cmd = { './node_modules/.bin/pyright-langserver', '--stdio' },
  installer = [[
  set -e
  npm install pyright
  ]],
}
