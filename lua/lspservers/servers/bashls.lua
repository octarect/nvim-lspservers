local server = require'lspservers/server'

return server.new{
  name = 'bashls',
  cmd = { './node_modules/.bin/bash-language-server', 'start' },
  installer = [[
    set -e
    npm install bash-language-server
  ]],
}
