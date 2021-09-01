local libos = require 'lspservers/libos'

describe('libos', function()
  describe('exists()', function()
    it('should return true for the file exists', function()
      -- This file
      local file = debug.getinfo(1).source:match '@?(.*)'
      assert.is_true(libos.exists(file))
    end)

    it('should return false when the file is not found', function()
      local plugin_path = debug.getinfo(1).source:match '@?(.*)/.*/.*/.*'
      local dummy_file = plugin_path .. '/dummy'
      assert.is_not_true(libos.exists(dummy_file))
    end)
  end)

  describe('path_join()', function()
    it('should concatenate two paths', function()
      assert.are.same(libos.path_join('/foo/bar', 'demo.txt'), '/foo/bar/demo.txt')
    end)

    it('should remove duplicate slashes', function()
      assert.are.same(libos.path_join('/foo/bar/', 'demo.txt'), '/foo/bar/demo.txt')
    end)

    it('should return a path without a trailing slash', function()
      assert.are.same(libos.path_join('/foo/bar', 'baz/'), '/foo/bar/baz')
    end)
  end)
end)
