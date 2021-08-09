set rtp+=.
set rtp+=/opt/plenary.nvim/
set rtp+=/opt/nvim-lspconfig/
set rtp+=/opt/lspservers.nvim/

runtime! plugin/plenary.vim
runtime! plugin/lspconfig.vim
runtime! plugin/lspservers.vim

function! SetupLspServers() abort
lua << EOF
require'lspservers'.setup{
  installation_path = '/opt/lspservers',
  servers = {
    vimls = true,
    sumneko_lua = true,
  },
}
EOF
endfunction

command! -nargs=0 TestSetup call SetupLspServers()
