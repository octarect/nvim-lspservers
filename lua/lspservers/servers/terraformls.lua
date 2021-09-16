local server = require 'lspservers/server'

local platform = 'linux'
if vim.fn.has 'mac' == 1 then
  platform = 'darwin'
end

local installer = string.format(
  [[
set -e
platform='%s'

latest_api_url="https://api.github.com/repos/hashicorp/terraform-ls/releases/latest"
response="$(curl -s "$latest_api_url")"
version="$(echo "$response" | grep tag_name | sed -E 's/\ *"tag_name":\ *"v([^"]+)".*/\1/')"
echo "version v$version will be installed. (CI=${CI:-false})"

arch=amd64
asset="terraform-ls_${version}_${platform}_${arch}.zip"
release_url="https://github.com/hashicorp/terraform-ls/releases/download/v$version/$asset"
curl -L "$release_url" -o $asset
unzip $asset
rm $asset

chmod +x terraform-ls
  ]],
  platform
)

return server.new {
  name = 'terraformls',
  cmd = { './terraform-ls', 'serve' },
  installer = installer,
}
