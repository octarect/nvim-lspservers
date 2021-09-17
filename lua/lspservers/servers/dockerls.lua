local server = require 'lspservers/server'

return server.new {
  name = 'dockerls',
  cmd = { './node_modules/.bin/docker-langserver', '--stdio' },
  installer = [[
  set -e
  npm install dockerfile-language-server-nodejs
  ]],
}
