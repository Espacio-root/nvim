local M = require("keymaps")
local group = vim.api.nvim_create_augroup("ofseed", {})
local custom = require("customization")

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

-- function ColorMyPencils()
--     vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
--     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none", ctermbg="NONE" })
--     vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE", ctermbg = "NONE" })
--     vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE", ctermbg = "NONE" })
--     -- etc...
-- end

-- vim.api.nvim_create_augroup("nobg", { clear = true })
-- vim.api.nvim_create_autocmd({ "ColorScheme" }, {
--   desc = "Make all backgrounds transparent",
--   group = "nobg",
--   pattern = "*",
--   callback = ColorMyPencils,
-- })

-- autocmd to change kitty padding
-- vim.cmd [[
-- augroup kitty_mp
--     autocmd!
--     au VimLeave * :silent !kitty @ set-spacing padding=20 margin=10
--     au VimEnter * :silent !kitty @ set-spacing padding=0 margin=0
-- augroup END
-- ]]

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

local function get_neotree_winid()
  local window_table = vim.fn.getwininfo()
  for _, win_info in ipairs(window_table) do
    if win_info.variables and win_info.variables.neo_tree_settings_applied then
      return win_info.winid
    end
  end
  return nil
end

vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
  pattern = "*",
  desc = "Update neotree size",
  callback = function()
    local winid = get_neotree_winid()
    if winid then
      vim.api.nvim_win_set_width(winid, custom.width())
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})

local texgroup = vim.api.nvim_create_augroup("Tex", {})

-- Remaps ; to \ and \ to ; in tex files
vim.api.nvim_create_autocmd("FileType", {
  group = texgroup,
  pattern = { "tex", "latex" },
  callback = M.remap_tex,
})

-- Disable copilot for certain filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = {"python"},
--   callback = function()
--     vim.cmd("Copilot disable")
--   end,
-- })

-- Disable treesiter for latex files
-- vim.api.nvim_create_autocmd("FileType", {
--   group = texgroup,
--   pattern = {"tex", "latex"},
--   callback = function()
--     vim.cmd("TSBufDisable")
--   end,
-- })


vim.api.nvim_create_user_command("ConvertToTex", function()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath:match("%.ipynb$") or filepath:match("%.py$") then
    require("customization").ipynb_to_tex(filepath)
  end
end, {})

vim.api.nvim_create_user_command("CreateIpynb", function(opts)
  local filepath = vim.fn.expand("%:p:h") .. "/" .. opts.args .. ".ipynb"
  if filepath:match("%.ipynb$") then
    require("customization").create_notebook(filepath)
  end
  vim.cmd("e " .. filepath)
end, {nargs = 1})
