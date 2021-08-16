local config = require'lspservers/config'
local command = require'lspservers/command'
local servers = require'lspservers/servers'
local M = {}

local ex_commands = {
  Install = {
    repl = "lua require'lspservers'.install(<f-args>)",
    args = {
      nargs = '+',
      complete = 'custom,lspservers#completion#available_servers',
    },
  },
  Uninstall = {
    repl = "lua require'lspservers'.uninstall(<f-args>)",
    args = {
      nargs = '+',
      complete = 'custom,lspservers#completion#installed_servers',
    },
  },
  Update = {
    repl = "lua require'lspservers'.update(<f-args>)",
    args = {
      nargs = '*',
      complete = 'custom,lspservers#completion#installed_servers',
    },
  },
}

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

-- setup() is called by user to configure this plugin.
function M.setup(opts)
  local new_servers = {}

  config.setup(opts)

  define_ex_commands('LspServers', ex_commands)

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

function define_ex_commands(prefix, commands)
  for name, def in pairs(commands) do
    local attr = {}
    for k, v in pairs(def.args or {}) do
      table.insert(attr, string.format('-%s=%s', k, v))
    end
    local cmd = prefix .. name
    local parts = vim.tbl_flatten {
      "command!",
      attr,
      cmd,
      def.repl,
    }
    vim.api.nvim_command(table.concat(parts, ' '))
  end
end

return M
