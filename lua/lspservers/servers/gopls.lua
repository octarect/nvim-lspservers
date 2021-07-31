local server = require'lspservers/server'

return server.new({
  name = 'gopls',
  cmd = { './gopls' },
  installer = [[
    set -e
    GOPATH=$(pwd) GOBIN=$(pwd) GO111MODULE=on go get -v golang.org/x/tools/gopls
    GOPATH=$(pwd) GO111MODULE=on go clean -modcache
  ]],
})
