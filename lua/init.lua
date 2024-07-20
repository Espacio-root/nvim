local custom = require "customization"

require "options"
require "keymaps"
require "autocmds"
require "lsp"
require "manager"

gen_matrix = function(row, col)
  local tbl = {}
  for m = 1,row do
    table.insert(tbl, "i(" .. ((m-1)*col)+1 .. ")")
    for n = 2,col do
      table.insert(tbl, "t(" .. "\" & \"" .. ")")
      table.insert(tbl, "i(" .. ((m-1)*col)+n .. ")")
    end
    if m ~= row then
      table.insert(tbl, "t({ \" \\\\\", \"  \" })")
    end
  end
  table.insert(tbl, "t(\"\")")
  return tbl
end

vim.cmd.colorscheme(custom.theme)
