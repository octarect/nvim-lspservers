local lspservers = require'lspservers'

describe('lspservers', function()
  describe('install', function()
    it('should be true', function()
      lspservers.install(gopls)
      assert(true)
    end)
  end)
end)
