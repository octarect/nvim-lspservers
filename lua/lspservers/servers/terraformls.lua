local server = require 'lspservers/server'

return server.new {
  name = 'terraformls',
  cmd = { './terraform-ls', 'serve' },
  installer = [[
  set -e
  platform=$(uname -s | tr "[:upper:]" "[:lower:]")

  if [ "$CI" = "true" ]; then
    version="0.22.0"
  else
    latest_api_url="https://api.github.com/repos/hashicorp/terraform-ls/releases/latest"
    response="$(curl -s "$latest_api_url")"
    version="$(echo "$response" | grep tag_name | sed -E 's/\ *"tag_name":\ *"v([^"]+)".*/\1/')"
    if [ -z "$version" ]; then
      echo "Unexpected response from github api:"
      echo "$response"
      exit 1
    fi
  fi
  echo "version v$version will be installed. (CI=${CI:-false})"

  arch=amd64
  asset="terraform-ls_${version}_${platform}_${arch}.zip"
  release_url="https://github.com/hashicorp/terraform-ls/releases/download/v$version/$asset"
  curl -L "$release_url" -o $asset
  unzip $asset
  rm $asset

  chmod +x terraform-ls
  ]],
}
