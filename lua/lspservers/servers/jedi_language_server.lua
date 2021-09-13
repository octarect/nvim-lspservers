local server = require 'lspservers/server'

return server.new {
  name = 'jedi_language_server',
  cmd = { './jedi-language-server' },
  installer = [[
    set -e
    python3 -m venv ./venv 1>&2
    ./venv/bin/pip3 install -U pip
    ./venv/bin/pip3 install -U jedi-language-server
    ln -s "./venv/bin/jedi-language-server" .
  ]],
}
