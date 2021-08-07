local config = require'lspservers/config'
local command = require'lspservers/command'
local servers = require'lspservers/servers'
local M = {}

function M.install(...)
  local cmds = {}
  for _, name in ipairs({...}) do
    if servers[name] ~= nil then
      table.insert(cmds, servers[name]:install())
    end
  end
  command.exec(cmds)
end

function M.uninstall(...)
  local cmds = {}
  for _, name in ipairs({...}) do
    if servers[name] ~= nil then
      table.insert(cmds, servers[name]:uninstall())
    end
  end
  command.exec(cmds)
end

function M.get_installed_servers()
  return vim.tbl_filter(function(s)
    return s:is_installed()
  end, servers)
end

-- setup() is called by user to configure this plugin.
function M.setup(opts)
  config.setup(opts)
  if #config.default_servers > 0 then
    M.install(unpack(config.default_servers))
  end
end

return M
