set rtp+=.

runtime! plugin/plenary.vim
runtime! plugin/lspconfig.vim
runtime! plugin/lspservers.vim

function! SetupLspServers() abort
lua << EOF
require'lspservers'.setup{
  servers = {
    vimls = true,
    sumneko_lua = true,
  },
}
EOF
endfunction

command! -nargs=0 TestSetup call SetupLspServers()
