vim.g.mapleader = " "
vim.g.maplocalleader = "  "

-- move through windows
vim.keymap.set("", "<C-h>", function() vim.cmd("wincmd h") end, { noremap=true, silent=true })
vim.keymap.set("", "<C-l>", function() vim.cmd("wincmd l") end, { noremap=true, silent=true })
vim.keymap.set("", "<C-j>", function() vim.cmd("wincmd j") end, { noremap=true, silent=true })
vim.keymap.set("", "<C-k>", function() vim.cmd("wincmd k") end, { noremap=true, silent=true })
