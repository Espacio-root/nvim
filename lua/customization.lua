local M = {}

-- M.theme = "kanagawa-dragon"
M.theme = "kanagawa"
M.prefer_tabpage = false
M.border = "rounded"
M.shell = "fish"

M.width = function()
  local min_width = 25
  local max_width = 40
  local preferred_width = math.floor(vim.go.columns * 0.2)
  return math.min( math.max(preferred_width, min_width), max_width )
end

local append_space = function(icons)
  local result = {}
  for k, v in pairs(icons) do
    result[k] = v .. " "
  end
  return result
end

local kind_icons = {
  Array = "",
  Boolean = "",
  Class = "",
  Color = "",
  Constant = "",
  Constructor = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "",
  Module = "",
  Namespace = "",
  Null = "",
  Number = "",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "",
}

M.icons = {
  -- LSP diagnostic
  diagnostic = {
    error = "󰅚 ",
    warn = "󰀪 ",
    hint = "󰌶 ",
    info = "󰋽 ",
  },
  -- LSP kinds
  kind = kind_icons,
  kind_with_space = append_space(kind_icons),
}

M.ipynb_to_tex = function(filepath)
  local filename = filepath:match("^.+/(.+)%..+$")
  os.execute(string.format("jupyter nbconvert --log-level ERROR --to latex --template-file report.tex.j2 %s.ipynb", filename))

  -- Open the file in write mode
  filename = filename .. ".tex"
  local file = io.open(filename, "r")
  if not file then
    print("Failed to open file:", filename)
    return
  end

  -- Read the entire content
  local content = file:read("*all")
  file:close()

  -- Trim the content
  local begPos = content:find("\\begin{Verbatim}")
  local endPos = content:reverse():find(string.reverse("\\end{Verbatim}"))
  endPos = #content - endPos + 1
  local trimmedContent = content:sub(begPos, endPos)

  -- Open the file again in write mode
  local fileWrite = io.open(filename, "w")
  if not fileWrite then
    print("Failed to open file for writing:", filename)
    return
  end

  -- Write trimmed content back to the file
  fileWrite:write(trimmedContent)
  fileWrite:close()

  -- Print success message
  print("Successfully processed and wrote file:", filename)
end

M.create_notebook = function(path)
 local content = [[
{
 "cells": [],
 "metadata": {
  "kernelspec": {
   "display_name": "",
   "name": ""
  },
  "language_info": {
   "name": ""
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
 ]] 

  -- create a new file if it doesn't exist
  local file = io.open(path, "w")
  if not file then
    print("Failed to create file:", path)
    return
  end

  -- Write the content to the file
  file:write(content)
  file:close()

  print("Successfully created file:", path)
end

return M
