local M = {}

local DEFAULT_UPDATE_TIME = 500

local Progress = {}

-- Open progress UI.
-- It calls `update()` every `update_interval` (milliseconds),
-- so `update()` must be implemented in UI module (under lspservers/progress/)
function Progress:open()
  self.timer = vim.loop.new_timer()
  self.timer:start(0, self.update_interval, vim.schedule_wrap(function()
    self.ui:update()
  end))
end

-- Close progress UI.
function Progress:close(update)
  if update == nil then
    update = true
  end
  if update then
    self.ui:update()
  end
  if self.timer then
    self.timer:close()
    self.timer = nil
  end
end

-- Set message. `msg` will be outputted on next call of `self.ui:update()`
function Progress:print(msg)
  self.msg = msg
end

-- Show error message and close progress.
function Progress:error(msg)
  self:close(false)
  vim.api.nvim_err_write(msg)
end

function M.new(progress_type, update_interval)
  update_interval = update_interval or DEFAULT_UPDATE_TIME
  local data = {
    update_interval = update_interval,
    msg = '',
  }
  data.ui = require('lspservers/progress/' .. progress_type).new(data)
  return setmetatable(data, { __index = Progress })
end

return M
