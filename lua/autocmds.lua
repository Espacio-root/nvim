local smallTabs = { "lua", "javascript", "typescript" }

--  change tab size
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local filetype = vim.bo.filetype
    if vim.tbl_contains(smallTabs, filetype) then
      vim.o.tabstop = 2
      vim.o.shiftwidth = 2
    else
      vim.o.tabstop = 4
      vim.o.shiftwidth = 4
    end
  end,
})
