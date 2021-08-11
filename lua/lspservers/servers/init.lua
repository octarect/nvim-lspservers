local data = {}

-- Auto-require modules in ./lua/lspservers/servers/
local script_dir = debug.getinfo(1, 'S').source:match("@?(.*)/")
for filename in io.popen('ls -1 ' .. script_dir):lines() do
  if filename ~= 'init.lua' then
    local server_name = string.match(filename, '(.+).lua')

    data[server_name] = require('lspservers/servers/' .. server_name)
  end
end

return data
