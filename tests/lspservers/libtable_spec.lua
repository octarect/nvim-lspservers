local libtable = require'lspservers/libtable'

describe('libtable', function()
  describe('.contains()', function()
    it('should return true when a table has an expected element', function()
      assert.is_true(libtable.contains({'a', 'b', 'c'}, 'c'))
    end)
    it('should return false when an expected element is not found', function()
      assert.is_not_true(libtable.contains({'a', 'b', 'c'}, 'z'))
    end)
  end)

  describe('.keys()', function()
    it('should return an empty array when receiving an empty hash', function()
      assert.is_true(#libtable.keys({}) == 0)
    end)

    it('should return keys of a hash', function()
      local t = { foo=1, bar=2 }
      local keys = libtable.keys(t)
      assert.is_true(libtable.contains(keys, 'foo'))
      assert.is_true(libtable.contains(keys, 'bar'))
    end)
  end)

  describe('join()', function()
    it('should return an empty string when receiving an empty array', function()
      assert.is_true(libtable.join({}, ',') == '')
    end)

    it('should work correctly with a non-empty array', function()
        assert.is_true(libtable.join({'a', 'b', 'c'}, ',') == 'a,b,c')
    end)
  end)

  describe('split()', function()
    it('should return an empty array when receiving an empty string' ,function()
      assert.are.same(libtable.split('', ','), {})
    end)

    it('should split into a correct array with a specified delimiter', function()
      assert.are.same(libtable.split('a,b,c', ','), {'a', 'b', 'c'})
    end)
  end)
end)
