local utils = require "utils"
local custom = require "customization"
local mode = custom.prefer_tabpage and "tab" or "buffer"

return {
  "roobert/bufferline-cycle-windowless.nvim",
  dependencies = {
    { "akinsho/bufferline.nvim" },
  },
  config = function()
    require("bufferline-cycle-windowless").setup({
      -- whether to start in enabled or disabled mode
      default_enabled = true,
    })
  end,
  keys = {
    { "<S-l>", "<cmd>BufferLineCycleWindowlessNext<CR>", desc = utils.firstToUpper(mode), noremap = true, silent= true },
    { "<S-h>", "<cmd>BufferLineCycleWindowlessPrev<CR>", desc = utils.firstToUpper(mode), noremap = true, silent = true },
    { "<S-t>", "<cmd>BufferLineCycleWindowlessToggle<CR>", desc = utils.firstToUpper(mode), noremap = true, silent = true },
  }
}
