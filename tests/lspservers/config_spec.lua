local config = require'lspservers/config'

describe('config', function()
  describe('.set_default()', function()
    it('should be able to set a default value', function()
      config.set_default()
      assert.are.same(config.default_installation_path(), config.installation_path)
    end)

    it('should be able to set a custom value', function()
      local installation_path = '/opt/lspservers'
      vim.api.nvim_set_var('lspservers_installation_path', installation_path)
      config.set_default()
      assert.are.same(installation_path, config.installation_path)
    end)
  end)
end)
