local M = {}

local CommandJob = {}

function CommandJob:run(ctx)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)

  local handle
  handle = vim.loop.spawn(
    self.cmd,
    {
      args = self.args,
      cwd = self.cwd,
      stdio = { nil, stdout, stderr },
    },
    vim.schedule_wrap(function(code, _)
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      handle:close()

      if code ~= 0 then
        -- Show error message
        ctx:error(function(msg)
          return string.format('Failed to execute the command with code: %s: %s', code, msg)
        end)

        -- Invoke error callback function
        if self.error_cb ~= nil then
          self.error_cb(ctx)
        end

        return
      else
        -- Invoke success callback function
        if self.success_cb ~= nil then
          self.success_cb(ctx)
        end

        -- Complete job
        ctx:done(self)

        return
      end
    end)
  )

  if handle == nil then
    stdout:close()
    stderr:close()

    ctx:error(function()
      return string.format('Failed to start command: %s', self:get_summary())
    end)

    return false
  end

  vim.loop.read_start(stdout, self:_on_read(ctx, 'stdout'))
  vim.loop.read_start(stderr, self:_on_read(ctx, 'stderr'))

  return true
end

function CommandJob:get_summary()
  local s = self.cmd
  if self.args ~= nil and #self.args > 0 then
    for _, v in ipairs(self.args) do
      s = s .. ' ' .. v
    end
  end
  return s
end

function CommandJob:_on_read(ctx, type)
  return vim.schedule_wrap(function(_, out)
    if out then
      out = string.gsub(out, '\n$', '')
      ctx:log(type, out)
    end
  end)
end

function M.new(cmd)
  return setmetatable(cmd, { __index = CommandJob })
end

return M
