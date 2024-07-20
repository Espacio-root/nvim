local opts = { mode = "n", silent = "true", noremap = "true" }

return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function()
    require("chatgpt").setup()
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim"
  },
  keys = {
    { "<leader>ago", function() require("chatgpt").edit_with_instructions() end, opts }
  }
}
