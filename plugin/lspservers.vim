if exists('g:loaded_nvim_lspservers') | finish | endif

let s:save_cpo = &cpo
set cpo&vim


let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_nvim_lspservers = 1
