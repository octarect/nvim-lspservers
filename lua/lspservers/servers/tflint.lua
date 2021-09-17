local server = require 'lspservers/server'

return server.new {
  name = 'tflint',
  cmd = { './tflint', '--langserver' },
  installer = [[
  set -e
  os=$(uname -s | tr "[:upper:]" "[:lower:]")
  case $os in
  linux)
    platform=linux_amd64
    ;;
  darwin)
    platform=darwin_amd64
    ;;
  esac

  asset=tflint_$platform.zip
  url=https://github.com/terraform-linters/tflint/releases/latest/download/$asset
  curl -L -o $asset $url

  unzip $asset
  chmod +x tflint
  ]],
}
