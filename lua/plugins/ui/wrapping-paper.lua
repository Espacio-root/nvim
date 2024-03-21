return {
  "benlubas/wrapping-paper.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<C-e>",
      "<cmd>lua require('wrapping-paper').wrap_line()<CR>",
      mode = "n",
    }
  }
}
