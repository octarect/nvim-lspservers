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
end

M.setup()

return M
