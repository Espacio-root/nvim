vim.g.mapleader = " "
vim.g.maplocalleader = "  "

-- convenient pastes
-- vim.keymap.set("n", "p", "\"0p", { noremap = true })

-- move through windows
vim.keymap.set("n", "<C-h>", function() vim.cmd("wincmd h") end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", function() vim.cmd("wincmd l") end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", function() vim.cmd("wincmd j") end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", function() vim.cmd("wincmd k") end, { noremap = true, silent = true })

-- resize windows through vim motions
-- vim.keymap.set('n', '<C-S-K>', function() vim.cmd("resize +2") end, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-S-J>', function() vim.cmd("resize -2") end, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-S-L>', function() vim.cmd("vertical resize -2") end, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-S-H>', function() vim.cmd("vertical resize +2") end, { noremap = true, silent = true })

-- resize windows

-- debug window
local virtual_text = false
local toggle_virtual_text = function()
  if virtual_text then
    vim.diagnostic.config {
      virtual_text = false
    }
  else
    vim.diagnostic.config {
      virtual_text = {
        spacing = 4,
        prefix = "●",
        severity = vim.diagnostic.severity.ERROR
      }
    }
  end
  virtual_text = not virtual_text
  vim.notify("virtual_text set to " .. tostring(virtual_text))
end

vim.keymap.set("n", "<leader>ld", toggle_virtual_text, {noremap = true, silent = true, desc = "Toggle virtual text"})

-- toggle quickfix
local function toggle_quickfix()
  local wins = vim.fn.getwininfo()
  local qf_win = vim
      .iter(wins)
      :filter(function(win)
        return win.quickfix == 1
      end)
      :totable()
  if #qf_win == 0 then
    vim.cmd.copen()
  else
    vim.cmd.cclose()
  end
end

vim.keymap.set("n", "<leader>q", toggle_quickfix, { desc = "Quickfix" })
vim.keymap.set("n", "<leader>tq", toggle_quickfix, { desc = "Quickfix" })
