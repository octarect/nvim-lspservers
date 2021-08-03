local config = require'lspservers/config'
local status = require'lspservers/status'
local libos = require'lspservers/libos'
local lspconfig = require'lspconfig'
local M = {}
local Server = {}

function extend_command_path(cmd, server_name)
  local relative_path = cmd[1]
  local server_dir = libos.path_join(config.installation_path, server_name)
  local server_command_path = libos.path_join(server_dir, relative_path)
  cmd[1] = server_command_path
  return cmd
end

function Server:get_installation_path()
  return libos.path_join(config.installation_path, self.name)
end

function Server:setup(opts)
  local opts = opts or {}
  opts.cmd = extend_command_path(self.cmd, self.name)
  lspconfig[self.name].setup(opts)
end

function Server:install()
  local installation_path = self:get_installation_path()
  if not(libos.is_dir(installation_path)) then
    self:_mkdir()
  end

  return {
    cmd = 'bash',
    args = { '-c', self.installer },
    progress = string.format('Installing %s', self.name),
    cwd = installation_path,
    success_cb = function(stdout, stderr)
      status.add_server(self.name)
    end,
    error_cb = function(stdout, stderr)
      if libos.is_dir(installation_path) then
        self:_rollback()
      end
    end,
  }
end

function Server:uninstall()
  return {
    cmd = 'rm',
    args = { '-rf', self.name },
    progress = string.format('Removing %s', self.name),
    cwd = config.installation_path,
    success_cb = function(stdout, stderr)
      status.remove_server(self.name)
    end,
  }
end

function Server:_mkdir()
  local installation_path = self:get_installation_path()
  local code = os.execute('mkdir -p ' .. installation_path)
  if code ~= 0 then
    vim.api.nvim_err_writeln(
      string.format('Cannot create directory: code=%d, path=%s', code, installation_path)
    )
  end
end

function Server:_rollback()
  local installation_path = self:get_installation_path()
  local code = os.execute('rm -rf ' .. installation_path)
  if code ~= 0 then
    vim.api.nvim_err_writeln(
      string.format('Cannot remove directory: code=%d, path=%s', code, installation_path)
    )
  end
end

function M.new(args)
  return setmetatable(args, {__index = Server})
end

return M
