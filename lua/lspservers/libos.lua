local M = {}

function M.exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
    return false
  end
  return true
end

function M.is_dir(path)
  if string.sub(path, #path, #path) ~= '/' then
    path = path .. '/'
  end
  return M.exists(path)
end

function M.path_join(path1, path2)
  if path1 == nil or path1 == '' then
    return path2 or ''
  end
  path1 = string.gsub(path1, '/$', '')
  if path2 == nil or path2 == '' then
    return path1
  end
  path2 = string.gsub(path2, '/$', '')
  return path1 .. '/' .. path2
end

return M
