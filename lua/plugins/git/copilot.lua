return {
  "github/copilot.vim",
  event = "VeryLazy",
  init = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_disable = true
  end,
  -- config = function()
  --   vim.cmd(":Copilot disable")
  -- end,
  cmd = "Copilot",
  keys = {
    {
      "<C-f>",
      'copilot#Accept("<CR>")',
      mode = "i",
      silent = true,
      expr = true,
      script = true,
      replace_keycodes = false
    }
  }
}
