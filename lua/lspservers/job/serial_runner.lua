local context = require 'lspservers/job/context'

local M = {}

-- SerialRunner executes jobs sequantially
local SerialRunner = {}

function SerialRunner:run(jobs)
  self.jobs = jobs
  local ctx = context.new(self, jobs)
  if #self.jobs > 0 then
    self:_run_next_job(ctx)
  end
end

function SerialRunner:done(ctx, _)
  self:_run_next_job(ctx)
end

function SerialRunner:_run_next_job(ctx)
  local job = self.jobs[ctx.job_i]
  if job then
    ctx:print(job.progress or job:get_summary())
    job:run(ctx)
  else
    ctx:print 'Done!'
  end
end

function M.new(logger)
  local data = { logger = logger }
  return setmetatable(data, { __index = SerialRunner })
end

return M
