local server = require 'lspservers/server'

return server.new {
  name = 'vimls',
  cmd = { './node_modules/.bin/vim-language-server', '--stdio' },
  installer = [[
  set -e
  npm install vim-language-server@latest
  ]],
}
