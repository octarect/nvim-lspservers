local status = require'lspservers.status'

local servers = {
  foo = true,
  bar = true,
  baz = true,
}
local serialized = 'bar,baz,foo'

describe('status', function()
  describe('.serialize()', function()
    it('should return server names which is sorted and separated by comma', function()
      assert.are.equal(status.serialize(servers), serialized)
    end)

    it('should return an empty string when receiving an empty hash', function()
      assert.are.equal(status.serialize({}), '')
    end)
  end)

  describe('.unserialize()', function()
    it('should return a hash containing server names as keys', function()
      assert.are.same(status.unserialize(serialized), servers)
    end)

    it('should return a empty hash when receiving an empty string', function()
      assert.are.same(status.unserialize(''), {})
    end)
  end)
end)
