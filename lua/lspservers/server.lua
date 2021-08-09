local config = require'lspservers/config'
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

function Server:get_config()
  return config.servers[self.name]
end

function Server:is_installed()
  return libos.is_dir(self:get_installation_path())
end

function Server:setup(server_config)
  local server_config = server_config or {}
  server_config.cmd = extend_command_path(self.cmd, self.name)
  lspconfig[self.name].setup(server_config)
end

function Server:setup_auto()
  local priority = {
    config.global,
    self:get_config().config,
  }
  if self:get_config().auto_config then
    table.insert(priority, 1, self.auto_config or {})
  end
  local server_config = vim.tbl_deep_extend('force', unpack(priority))
  self:setup(server_config)
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
    success_cb = function(_, _)
      self:setup_auto()
    end,
    error_cb = function(_, _)
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
