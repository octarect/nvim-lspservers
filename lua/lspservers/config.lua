local M = {}

function M.default_installation_path()
  return os.getenv('HOME') .. '/.local/share/nvim/lspservers'
end

function M.setup(opts)
  opts = opts or {}
  M._set_defaults(opts)
end

function M._set_defaults(opts)
  local set = function(key, default)
    if type(default) == 'function' then
      M[key] = opts[key] or default()
    else
      M[key] = opts[key] or default
    end
  end

  set('installation_path', M.default_installation_path)
  set('global', {})

  M.default_servers = {}
  M.server_configs = {}
  for name, server_config in pairs(opts['servers'] or {}) do
    if server_config then
      table.insert(M.default_servers, name)
      if type(server_config) == 'table' then
        M.server_configs[name] = server_config
      else
        M.server_configs[name] = {}
      end
    end
  end
end

M.setup()

return M
