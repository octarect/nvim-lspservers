local command = require'lspservers.command'

describe('command', function()
  it('should succeed', function()
    command.exec({
      cmd = 'ls',
      args = {'-l'},
      success_cb = function(stdout, _)
        finished = 1
      end
    })
  end)
end)
