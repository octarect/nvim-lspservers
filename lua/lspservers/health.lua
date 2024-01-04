local M = {}

local REQUIRED_TOOLS = {
  {
    name = 'golang',
    command = 'go',
    get_version = function()
      local output = M._read_from_command 'go version'
      local version = string.match(output, 'go[%d.]+.+')
      return version
    end,
  },
  {
    name = 'npm',
    command = 'npm',
    get_version = function()
      return M._read_from_command 'npm --version'
    end,
  },
  {
    name = 'bundler (ruby)',
    command = 'bundle',
    get_version = function()
      return M._read_from_command 'bundle --version'
    end,
  },
  {
    name = 'pip',
    command = 'pip',
    get_version = function()
      local output = M._read_from_command 'pip --version'
      local version = string.match(output, 'pip [%d.]+')
      return version
    end,
  },
  {
    name = 'erlang',
    command = 'erl',
    get_version = function()
      local cmd = 'erl -eval "erlang:display(erlang:system_info(otp_release)), halt()."  -noshell'
      local output = M._read_from_command(cmd)
      local version = string.match(output, '%d+')
      if version then
        return 'OTP ' .. version
      end
      return ''
    end,
  },
}

local health_start = vim.health.start
local health_ok = vim.health.ok
local health_error = vim.health.error
local health_warn = vim.health.warn

function M._read_from_command(command)
  local f = io.popen(command, 'r')
  local str = f:read '*a'
  f:close()
  str = string.gsub(str, '\n', '')
  return str
end

function M.check()
  health_start 'Required tools'
  for _, tool in ipairs(REQUIRED_TOOLS) do
    local exist = vim.fn.has(tool.command)
    local version = ''
    if exist then
      version = tool.get_version()
    end
    if exist and type(version) == 'string' and #version > 0 then
      health_ok(string.format('%s found (%s)', tool.name, version))
    else
      health_warn(string.format('%s not found', tool.name))
    end
  end
end

return M
