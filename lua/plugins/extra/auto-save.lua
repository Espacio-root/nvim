return {
  "okuuva/auto-save.nvim",
  -- cmd = "ASToggle", -- optional for lazy loading on command
  opts = {
    enabled = false,
    event = { "InsertLeave", "TextChanged" },
  },
  keys = {
    { "<leader>sa", ":ASToggle<CR>", desc = "Toggle auto-save" },
  },
  -- config = function()
  --   require("auto-save").setup { enabled = false }
  --   vim.cmd[[ASToggle]]
  -- end,
}
