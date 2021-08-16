local config = require'lspservers/config'
local command = require'lspservers/command'
local servers = require'lspservers/servers'
local M = {}

function M.install(...)
  local cmds = {}
  for _, name in ipairs({...}) do
    if servers[name] == nil then
      -- Abort when non-existent server is specified.
      return vim.api.nvim_err_writeln(
        string.format('Server not found: %q', name)
      )
    else
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

function M.update(...)
  local args = {...}
  if #args == 0 then
    args = config.default_servers
  end

  local cmds = {}
  for _, name in ipairs(args) do
    if servers[name] ~= nil then
      local install, uninstall = unpack(servers[name]:update_commands())
      table.insert(cmds, uninstall)
      table.insert(cmds, install)
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
  local new_servers = {}

  config.setup(opts)

  -- Setup servers
  for _, server_name in ipairs(config.default_servers) do
    local server = servers[server_name]
    if server ~= nil then
      if server:is_installed() then
        server:setup_auto()
      else
        table.insert(new_servers, server_name)
      end
    end
  end

  -- Automatically install servers when they aren't installed
  if #new_servers > 0 then
    M.install(unpack(new_servers))
  end

  return M
end

return M
