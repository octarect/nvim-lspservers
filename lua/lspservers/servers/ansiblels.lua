local server = require 'lspservers/server'

return server.new {
  name = 'ansiblels',
  cmd = { './node_modules/.bin/ansible-language-server', '--stdio' },
  installer = [[
  set -e
  npm install @ansible/ansible-language-server
  ]],
}
