local M = {}

local Echo = {}

function Echo:update()
  print(self.progress.msg)
end

function M.new(progress)
  return setmetatable({ progress = progress }, { __index = Echo })
end

return M
