function! health#lspservers#check()
  lua require'lspservers/health'.check_health()
endfunction
