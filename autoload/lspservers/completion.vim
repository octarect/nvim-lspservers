function s:current_args(cmdline) abort
  return split(a:cmdline, ' ')[1:-1]
endfunction

function s:remove_selected(list, cmdline) abort
  let l:args = s:current_args(a:cmdline)
  echo l:args
  return filter(a:list, "index(l:args, v:val) == -1")
endfunction

function! lspservers#completion#available_servers(arglead, cmdline, pos) abort
  let l:server_names = keys(luaeval("require'lspservers/alias'.available()"))
  return join(s:remove_selected(l:server_names, a:cmdline), "\n")
endfunction

function! lspservers#completion#installed_servers(arglead, cmdline, pos) abort
  let l:servers = luaeval("require'lspservers/alias'.installed()")
  if empty(l:servers)
    return ''
  end
  let l:server_names = keys(l:servers)
  return join(s:remove_selected(l:server_names, a:cmdline), "\n")
endfunction
