local M = {}

function load_vim_var(config_key, vim_var, default_value_f)
  M[config_key] = vim.g[vim_var] or default_value_f()
end

function M.set_default()
  load_vim_var('installation_path', 'lspservers_installation_path', M.default_installation_path)
end

function M.default_installation_path()
  return os.getenv('HOME') .. '/.local/share/nvim/lspservers'
end

return M
