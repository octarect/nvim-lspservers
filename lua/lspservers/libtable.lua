local M = {}

function M.contains(t, e)
  for _, v in ipairs(t) do
    if v == e then
      return true
    end
  end
  return false
end

function M.keys(t)
  local keys = {}
  for k, _ in pairs(t) do
    table.insert(keys, k)
  end
  return keys
end

function M.join(t, delimiter)
  delimiter = delimiter or ' '

  local s = ''
  local len = #t
  table.foreachi(t, function(i, v)
    s = s .. v
    if i < len then
      s = s .. delimiter
    end
  end)

  return s
end

function M.split(s, delimiter)
  local result = {}
  local buf = ''
  local len = #s
  local delim_len = #delimiter
  local i = 1
  local idx = function(s, i) return string.sub(s, i, i) end
  while i <= len do
    if idx(s, i) == idx(delimiter, 1) then
      local remaining = delim_len - 1
      local passed_len = 1
      local passed = idx(s, i)
      while remaining > 0 do
        if idx(s, i + passed_len) == idx(delimiter, passed_len + 1) then
          passed = passed .. idx(s, i + passed_len)
          passed_len = passed_len + 1
          remaining = remaining - 1
        else
          break
        end
      end
      if remaining == 0 then
        table.insert(result, buf)
        buf = ''
      else
        buf = buf .. passed
      end
      i = i + passed_len
    else
      buf = buf .. idx(s, i)
      i = i + 1
    end
  end
  if i > 1 then
    table.insert(result, buf)
  end
  return result
end

return M
