local server = require'lspservers/server'

-- Enable snippet support for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return server.new{
  name = 'html',
  cmd = { './node_modules/.bin/vscode-html-language-server', '--stdio' },
  installer = [[
    set -e
    npm install vscode-langservers-extracted
  ]],
  auto_config = {
    capabilities = capabilities,
  },
}
