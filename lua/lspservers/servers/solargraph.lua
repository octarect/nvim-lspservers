local server = require'lspservers/server'

return server.new{
  name = 'solargraph',
  cmd = { './run-solargraph', 'stdio' },
  installer = [[
    set -e
    git clone --depth=1 https://github.com/castwide/solargraph
    cd solargraph
    bundle install --without development --path vendor/bundle
    cd ..

cat <<"EOF" >./run-solargraph
#!/usr/bin/env bash
DIR=$(cd $(dirname $0); pwd)/solargraph
BUNDLE_GEMFILE=$DIR/Gemfile bundle exec ruby $DIR/bin/solargraph $*
EOF
    chmod +x ./run-solargraph
  ]]
}
