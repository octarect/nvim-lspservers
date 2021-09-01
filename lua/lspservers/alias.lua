local servers = require 'lspservers/servers'
local M = {}

function M.available()
  return servers
end

function M.installed()
  local result = {}
  for name, server in pairs(servers) do
    if server:is_installed() then
      result[name] = server
    end
  end
  return result
end

return M
