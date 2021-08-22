local M = {}

function show_message(ctx, msg, as_error)
  as_error = as_error or false

  progress = string.format('[lspservers] [%s/%s]', ctx.started_cnt, ctx.command_cnt)
  msg = string.format('%s %s', progress, msg)

  if as_error then
    vim.api.nvim_err_writeln(msg)
  else
    print(msg)
  end
end

function get_command(cmd)
  local s = cmd.cmd
  if cmd.args ~= nil and #cmd.args > 0 then
    for _, v in ipairs(cmd.args) do
      s = s .. ' ' .. v
    end
  end
  return s
end

function on_read(stream, type)
  return function(err, out)
    if out then
      stream[type] = stream[type] .. out
    end
  end
end

function on_read_stdout(stream)
  return function(err, out)
    if out then
      stream.stdout = stream.stdout .. out
    end
  end
end

function on_read_stderr(stream)
  return function(err, out)
    if out then
      stream.stderr = stream.stderr .. out
    end
  end
end

function M.exec(cmds, ctx)
  if #cmds == 0 then
    if ctx ~= nil and ctx.command_cnt > 0 then
      show_message(ctx, 'Done!!')
    end
    return
  end

  ctx = ctx or { command_cnt = #cmds, started_cnt = 0, stream = {} }
  ctx.started_cnt = ctx.started_cnt + 1

  local cmd = table.remove(cmds, 1)
  show_message(ctx, cmd.progress or 'Executing ' .. get_command(cmd))

  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local stream = { stdout = '',  stderr = '' }
  local handle
  handle = vim.loop.spawn(
    cmd.cmd,
    {
      args = cmd.args,
      cwd = cmd.cwd,
      stdio = {nil, stdout, stderr},
    },
    vim.schedule_wrap(function(code, signal)
      stdout:read_stop()
      stderr:read_stop()
      stdout:close()
      stderr:close()
      handle:close()

      if code ~= 0 then
        local msg = string.format(
          'Failed to execute the command with code %s: %s',
          code,
          stream.stderr
        )
        show_message(ctx, msg, true)

        if cmd.error_cb ~= nil then
          cmd.error_cb(stream.stdout, stream.stderr)
        end

        cmd.success_cb = nil
        cmd.error_cb = nil
        local debug_msg = 'while executing:\n' .. vim.fn.json_encode(cmd)
        show_message(ctx, debug_msg, true)

        return
      else
        if cmd.success_cb ~= nil then
          cmd.success_cb(stream.stdout, stream.stderr)
        end
        M.exec(cmds, ctx)
      end
    end)
  )
  vim.loop.read_start(stdout, on_read(stream, 'stdout'))
  vim.loop.read_start(stderr, on_read(stream, 'stderr'))
end

return M
