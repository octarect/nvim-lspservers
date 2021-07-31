local config = require'lspservers/config'
local libtable = require'lspservers.libtable'
local libos = require('lspservers.libos')
local M = {}

local data = {}

function get_cache_path()
  return libos.path_join(config.installation_path, 'servers.txt')
end

function save_file()
  local f = io.open(get_cache_path(), 'w')
  f:write(M.serialize(data))
  f:close()
end

function M.load_file()
  if not(libos.exists(get_cache_path())) then
    return
  end
  local f = io.open(get_cache_path(), 'r')
  data = M.unserialize(f:read())
  f:close()
end

function M.serialize(servers)
  local server_names = libtable.keys(servers)
  table.sort(server_names)
  return libtable.join(server_names, ',')
end

function M.unserialize(str)
  if str == nil or str == "" then
    return {}
  end

  local data = {}
  local server_names = libtable.split(str, ',')
  table.foreach(server_names, function(_, name)
    data[name] = true
  end)

  return data
end

function M.add_server(name)
  if data[name] == nil then
    data[name] = true
    save_file()
  end
end

function M.remove_server(name)
  if data[name] ~= nil then
    data[name] = nil
    save_file()
  end
end

function M.get_installed_servers()
  local ret = {}
  for server_name, _ in pairs(data) do
    ret[server_name] = require('lspservers/servers/' .. server_name)
  end
  return ret
end

function M.exists(server)
  return data[server] ~= nil
end

return M
