local group = vim.api.nvim_create_augroup("ofseed", {})

---@param scope "global" | "local"
local function set_breakindentopt(scope)
  local indent = vim.o.tabstop
  if vim.o.expandtab then
    indent = vim.o.shiftwidth
  end
  vim.api.nvim_set_option_value("breakindentopt", "shift:" .. indent, { scope = scope })
end
set_breakindentopt "global"
vim.api.nvim_create_autocmd({ "OptionSet" }, {
  group = group,
  pattern = { "shiftwidth", "tabstop" },
  desc = "Set 'breakindentopt' based on indent settings",
  callback = function()
    set_breakindentopt(vim.v.option_type)
  end,
})

vim.api.nvim_create_autocmd({
  "FocusGained",
  "BufEnter",
  "CursorHold",
}, {
  group = group,
  desc = "Reload buffer on focus",
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd "checktime"
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  --- A specific group easy to override
  group = vim.api.nvim_create_augroup("highlight_on_yank", {}),
  desc = "Briefly highlight yanked text",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Filetype specific
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "qf",
  desc = "Disallow change buf for quickfix",
  callback = function()
    vim.wo.winfixbuf = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "go,py",
  desc = "Set indent for go and python",
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = false
  end,
})

function ColorMyPencils()
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", ctermbg="NONE" })
    vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" })
    -- etc...
end

vim.api.nvim_create_augroup("nobg", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  desc = "Make all backgrounds transparent",
  group = "nobg",
  pattern = "*",
  callback = ColorMyPencils,
})

-- autocmd to change kitty padding
vim.cmd [[
augroup kitty_mp
    autocmd!
    au VimLeave * :silent !kitty @ set-spacing padding=20 margin=10
    au VimEnter * :silent !kitty @ set-spacing padding=0 margin=0
augroup END
]]

local kitty_group = vim.api.nvim_create_augroup("kitty_mp", {})

vim.api.nvim_create_autocmd("VimEnter", {
  group = kitty_group,
  pattern = "*",
  desc = "Set kitty padding",
  callback = function()
    vim.fn.system("kitty @ set-spacing padding=5")
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  group = kitty_group,
  pattern = "*",
  desc = "Set kitty padding",
  callback = function()
    vim.fn.system("kitty @ set-spacing padding=20")
  end,
})

vim.api.nvim_create_autocmd({"VimResized", "WinResized"}, {
  group = vim.api.nvim_create_augroup("resize", {}),
  pattern = "*",
  desc = "Update window size",
  callback = function()
    vim.cmd("wincmd =")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})
