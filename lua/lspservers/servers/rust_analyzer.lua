local server = require 'lspservers/server'

return server.new {
  name = 'rust_analyzer',
  cmd = { './rust-analyzer' },
  installer = [[
  set -e
  os=$(uname -s | tr "[:upper:]" "[:lower:]")
  case $os in
  linux)
    platform="x86_64-unknown-linux-gnu"
    ;;
  darwin)
    platform="x86_64-apple-darwin"
    ;;
  esac

  executable=rust-analyzer-$platform
  asset="$executable.gz"
  url="https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/$asset"
  curl -L -o $asset $url
  gzip -d $asset

  mv $executable rust-analyzer
  chmod +x rust-analyzer
  ]],
}
