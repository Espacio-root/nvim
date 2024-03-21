local ffi = require "ffi"

---@class foldinfo_T
---@field start integer
---@field level integer
---@field llevel integer
---@field lines integer
ffi.cdef [[
typedef struct {
    int start;  // line number where deepest fold starts
    int level;  // fold level, when zero other fields are N/A
    int llevel; // lowest level that starts in v:lnum
    int lines;  // number of lines from v:lnum to end of closed fold
} foldinfo_T;
]]

ffi.cdef [[
typedef struct {} Error;
typedef struct {} win_T;
foldinfo_T fold_info(win_T* win, int lnum);
win_T *find_window_by_handle(int Window, Error *err);
]]

local M = {}

--- Turn the first letter of a string to uppercase
---@param str string
---@return string uppercased
function M.firstToUpper(str)
  return (str:gsub("^%l", string.upper))
end

-- FFI
local error = ffi.new "Error"

---@param winid number
---@param lnum number
---@return foldinfo_T | nil
function M.fold_info(winid, lnum)
  local win_T_ptr = ffi.C.find_window_by_handle(winid, error)
  if win_T_ptr == nil then
    return
  end
  return ffi.C.fold_info(win_T_ptr, lnum)
end

return M
