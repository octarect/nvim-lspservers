local server = require 'lspservers/server'

return server.new {
  name = 'sumneko_lua',
  cmd = { './sumneko-lua-language-server' },
  installer = [[
  set -e
  os=$(uname -s | tr "[:upper:]" "[:lower:]")
  case $os in
  linux)
    platform=Linux
    ;;
  darwin)
    platform=macOS
    ;;
  esac

  if [ "$CI" = "true" ]; then
    # In GitHub Actions, some VM may have exceeded rate limit of GitHub API
    version="2.3.6"
  else
    # get latest version
    latest_api_url="https://api.github.com/repos/sumneko/vscode-lua/releases/latest"
    response="$(curl -s "$latest_api_url")"
    version="$(echo "$response" | grep "tag_name" | sed -E 's/\ *"tag_name":\ *"v([^"]+)".*/\1/')"
    if [ -z "$version" ]; then
      echo "Unexpected response from github api:"
      echo "$response"
      exit 1
    fi
  fi
  echo "version v$version will be installed. (CI=${CI:-false})"

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
