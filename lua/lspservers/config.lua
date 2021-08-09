local M = {}

function M.default_installation_path()
  return os.getenv('HOME') .. '/.local/share/nvim/lspservers'
end

function M.setup(opts)
  opts = opts or {}
  M._set_defaults(opts)
end

function M._set_defaults(opts)
  local set = function(dst, src, key, default)
    if src[key] == nil then
      if type(default) == 'function' then
        dst[key] = default()
      else
        dst[key] = default
      end
    else
      dst[key] = src[key]
    end
  end

  -- Where to install servers
  set(M, opts, 'installation_path', M.default_installation_path)

  -- Configuration which applied to all servers
  set(M, opts, 'global', {})

  M.default_servers = {}
  M.servers = {}
  for name, server_config in pairs(opts['servers'] or {}) do
    if server_config then
      if type(server_config) ~= 'table' then
        server_config = {}
      end

      table.insert(M.default_servers, name)
      M.servers[name] = {}

      -- Determines whether to apply its recommended config
      set(M.servers[name], server_config, 'auto_config', true)
      server_config.auto_config = nil

      -- Server config
      M.servers[name].config = server_config
    end
  end
end

M.setup()

return M
