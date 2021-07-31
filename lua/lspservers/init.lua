local config = require'lspservers/config'
local status = require'lspservers/status'
local command = require'lspservers/command'
local libtable = require'lspservers/libtable'
local libos = require'lspservers/libos'
local M = {}

function init()
  config.set_default()
  status.load_file()
end

function M.install(...)
  local server_names = {...}
  local cmds = {}

  for _, server in ipairs(server_names) do
    local server_path = libos.path_join(config.installation_path, server)

    -- Create directy in which the server will be installed
    if not(libos.is_dir(server_path)) then
      local code = os.execute('mkdir -p ' .. server_path)
      if code ~= 0 then
        vim.api.nvim_err_writeln(
          string.format('Cannot create directory: code=%d, path=%s', code, server_path)
        )
      end
    end

    if not(status.exists(server)) then
      local server_data = require('lspservers/servers/' .. server)
      table.insert(cmds, {
        cmd = 'bash',
        args = { '-c', server_data.installer },
        progress = string.format('Installing %s', server),
        cwd = server_path,
        success_cb = function(stdout, stderr)
          status.add_server(server)
        end
      })
    end
  end

  command.exec(cmds)
end

function M.uninstall(...)
  local server_names = {...}
  local cmds = {}

  for _, server in ipairs(server_names) do
    if status.exists(server) then
      table.insert(cmds, {
        cmd = 'rm',
        args = { '-rf', server },
        progress = string.format('Removing %s', server),
        cwd = config.installation_path,
        success_cb = function(stdout, stderr)
          status.remove_server(server)
        end
      })
    end
  end

  command.exec(cmds)
end

function M.get_installed_servers()
  return status.get_installed_servers()
end

init()

return M
