local server = require 'lspservers/server'

local platform = 'Linux'
if vim.fn.has 'mac' == 1 then
  platform = 'macOS'
end

local installer = string.format(
  [[
set -e
platform='%s'

# get latest version
latest_api_url="https://api.github.com/repos/sumneko/vscode-lua/releases/latest"
version="$(curl -s "$latest_api_url" | grep "tag_name" | sed -E 's/\ *"tag_name":\ *"v([^"]+)".*/\1/')"

release_url="https://github.com/sumneko/vscode-lua/releases/download/v$version/lua-$version.vsix"

curl -L "$release_url" -o tmp.vsix
unzip tmp.vsix
rm tmp.vsix

server_dir="$(cd ./extension/server; pwd)"
luals_cmd="$server_dir/bin/$platform/lua-language-server"

chmod +x "$luals_cmd"

cat <<EOF > ./sumneko-lua-language-server
$luals_cmd -E -e LANG=en $server_dir/main.lua \$*
EOF

chmod +x ./sumneko-lua-language-server
]],
  platform
)

return server.new {
  name = 'sumneko_lua',
  cmd = { './sumneko-lua-language-server' },
  installer = installer,
  auto_config = function()
    return {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file('', true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end,
}
