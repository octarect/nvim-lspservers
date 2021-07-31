if exists('g:loaded_nvim_lspservers') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=+ LspServersInstall lua require'lspservers'.install(<f-args>)
command! -nargs=+ LspServersUninstall lua require'lspservers'.uninstall(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_nvim_lspservers = 1
