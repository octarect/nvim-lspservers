local M = {}

local Context = {}

function Context:done(job)
  self.finished_cnt = self.finished_cnt + 1
  self.job_i = self.job_i + 1
  self.runner:done(self, job)
end

function Context:print(msg)
  local i = self.job_i
  if i > self.job_cnt then
    i = self.job_cnt
  end
  msg = string.format('[lspservers] [%s/%s] %s', i, self.job_cnt, msg)
  print(msg)
end

function Context:error(formatter)
  local msg = formatter(self.output.stderr)
  vim.api.nvim_err_write(msg)
end

function Context:log(type, msg)
  self.output.all = self.output.all .. msg .. '\n'
  self.output[type] = self.output[type] .. msg .. '\n'
end

function M.new(runner, jobs)
  local data = {
    job_i = 1,
    finished_cnt = 0,
    job_cnt = #runner.jobs,
    output = { all = '', stdout = '', stderr = '' },
    runner = runner,
  }
  return setmetatable(data, { __index = Context })
end

return M
