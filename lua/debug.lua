local function tableToString(tbl, indent)
    indent = indent or 0
    local str = ""
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            str = str .. string.rep(" ", indent) .. k .. ":\n"
            str = str .. tableToString(v, indent + 2)
        else
            str = str .. string.rep(" ", indent) .. k .. ": " .. tostring(v) .. "\n"
        end
    end
    return str
end

local function writeToFile(file, ...)
  local log_file = io.open(file, "a")
  if log_file then
    for _, table in ipairs({...}) do
      if type(table) ~= 'table' then
        table = {table}
      end
      if table then
        log_file:write(tableToString(table) .. "\n")
        log_file:write(string.rep("-", 5) .. "\n")
      end
    end
    log_file:write(string.rep("-", 20) .. "\n")
    log_file:close()
  end
end

local function resetFile(file)
  local log_file = io.open(file, "w")
  if log_file then
    log_file:close()
  end
end

local wr_group = vim.api.nvim_create_augroup('WinResize', { clear = true })

-- resize windows when new window is opened
local function normalizeTableValues(inputTable)
    local totalSum = 0
    
    -- Calculate the total sum
    for _, value in pairs(inputTable) do
        totalSum = totalSum + value
    end
    
    -- Normalize values
    local normalizedTable = {}
    for id, value in pairs(inputTable) do
        normalizedTable[id] = value / totalSum
    end
    
    return normalizedTable
end

function ResizeWindows()
  local log_file = "/home/espacio/neovim.txt"
  local event = vim.v.event
  local win_info = vim.fn.getwininfo()
  local cur_window = vim.api.nvim_get_current_win()
  local cur_win_info = nil
  event.windows = vim.tbl_filter(function(winid) return winid ~= cur_window end, event.windows)

  -- writeToFile(log_file, event, wininfo, cur_window)
  for _, table in ipairs(win_info) do
    if table.winid == cur_window then
      cur_win_info = table
      break
    end
  end

  local widths = {}
  for _, table in ipairs(win_info) do
    if table.winrow == cur_win_info.winrow then
      widths[table.winid] = table.width
    end
  end

  for _, id in ipairs(event.windows) do
    widths[id] = widths[id] + cur_win_info.width / #event.windows
  end
  --
  -- local normalized_widths = normalizeTableValues(widths)
  writeToFile(log_file, widths)

end

vim.api.nvim_create_autocmd("WinResized", {
  group = wr_group,
  pattern = "*",
  callback = ResizeWindows,
  desc = "Resize windows when new window is opened",
})

resetFile("/home/espacio/neovim.txt")
