local server = require 'lspservers/server'

return server.new {
  name = 'clangd',
  cmd = { './clangd', '--background-index' },
  installer = [[
  set -e

  os=$(uname -s | tr "[:upper:]" "[:lower:]")
  case $os in
  linux)
    platform=linux
    ;;
  darwin)
    platform=mac
    ;;
  esac

  if [ "$CI" = "true" ]; then
    version=12.0.1
  else
    # get latest version
    latest_api_url="https://api.github.com/repos/clangd/clangd/releases/latest"
    response="$(curl -s "$latest_api_url")"
    version="$(echo "$response" | grep "tag_name" | sed -E 's/\ *"tag_name":\ *"([^"]+)".*/\1/')"
    if [ -z "$version" ]; then
      echo "Unexpected response from github api:"
      echo "$response"
      exit 1
    fi
  fi
  echo "version $version will be installed. (CI=${CI:-false})"

  asset="clangd-$platform-$version.zip"
  extdir="clangd_$version"
  url="https://github.com/clangd/clangd/releases/download/$version/$asset"

  curl -L -o $asset $url
  unzip $asset
  cp "$extdir/bin/clangd" ./
  chmod +x clangd
  ]],
}
