local opts = { mode = "n", silent = "true", noremap = "true" }

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  dependencies = {
    { "zbirenbaum/copilot.lua" },   -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" },    -- for curl, log wrapper
  },
  opts = {
    debug = true,   -- Enable debugging
    -- See Configuration section for rest
  },
  -- See Commands section for default commands if you want to lazy load on them
  keys = {
    { "<leader>aco", "<cmd>CopilotChatToggle<cr>", opts },
    { "<leader>ace", "<cmd>CopilotChatExplain<cr>", opts },
  }
}
