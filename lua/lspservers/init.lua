local config = require'lspservers/config'
local status = require'lspservers/status'
local command = require'lspservers/command'
local servers = require'lspservers/servers'
local libtable = require'lspservers/libtable'
local libos = require'lspservers/libos'
local M = {}

function init()
  config.set_default()
  status.load_file()
end

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
  return status.get_installed_servers()
end

init()

return M
