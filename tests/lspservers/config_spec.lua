local config = require 'lspservers/config'

describe('config', function()
  describe('.setup()', function()
    it('should be able to set a default value', function()
      config.setup()
      assert.are.same(config.default_installation_path(), config.installation_path)
    end)

    it('should be able to set a custom value', function()
      local installation_path = '/opt/lspservers'
      config.setup { installation_path = installation_path }
      assert.are.same(installation_path, config.installation_path)
    end)
  end)
end)
