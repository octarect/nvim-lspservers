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

function Server:setup(opts)
  local opts = opts or {}
  opts.cmd = extend_command_path(self.cmd, self.name)
  lspconfig[self.name].setup(opts)
end

function M.new(args)
  return setmetatable(args, {__index = Server})
end

return M
