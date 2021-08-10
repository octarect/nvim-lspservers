local server = require'lspservers/server'

return server.new({
  name = 'yamlls',
  cmd = { './node_modules/.bin/yaml-language-server', '--stdio' },
  installer = [[
    set -e
    npm install yaml-language-server
  ]],
})
