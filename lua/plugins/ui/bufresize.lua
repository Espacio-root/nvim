local opts = { noremap = true, silent = true }
return {
  "kwkarlwang/bufresize.nvim",
  opts = {
    register = {
      keys = {
        { "n", "<C-S-H>",      "<C-w><",             opts },
        { "n", "<C-S-L>",      "<C-w>>",             opts },
        { "n", "<C-S-K>",      "<C-w>+",             opts },
        { "n", "<C-S-J>",      "<C-w>-",             opts },
        { "n", "<C-w>_",        "<C-w>_",             opts },
        { "n", "<C-w>=",        "<C-w>=",             opts },
        { "n", "<C-w>|",        "<C-w>|",             opts },
        { "",  "<LeftRelease>", "<LeftRelease>",      opts },
        { "i", "<LeftRelease>", "<LeftRelease><C-o>", opts },
      },
      trigger_events = { "BufWinEnter", "WinEnter" },
    },
    resize = {
      keys = {},
      trigger_events = { "VimResized" },
      increment = false,
    },
  }
}
