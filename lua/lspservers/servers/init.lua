local data = {}

-- TODO: wanna make the below server list automatically
local SERVERS = {
  "gopls",
  "vimls",
}

for _, server in ipairs(SERVERS) do
  data[server] = require('lspservers/servers/' .. server)
end

return data
