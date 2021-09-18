local server = require 'lspservers/server'

return server.new {
  name = 'cssls',
  cmd = { './node_modules/.bin/vscode-css-language-server', '--stdio' },
  installer = [[
  set -e
  npm install vscode-langservers-extracted
  ]],
  auto_config = function()
    return {
      settings = {
        css = {
          validate = true,
        },
        less = {
          validate = true,
        },
        scss = {
          validate = true,
        },
      },
    }
  end,
}
