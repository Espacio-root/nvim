local keys = require("keymaps")

return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  init = function()
    vim.o.showtabline = 2
    vim.o.tabline = " "
  end,
  config = function()
    require("bufferline").setup {
      options = {
        hover = {
          enabled = true,
          delay = 0,
          reveal = { "close" },
        },
        mode = "buffers",
        -- numbers = custom.prefer_tabpage and "ordinal" or "none",
        show_close_icon = false,
        offsets = {
          { filetype = "neo-tree", text = "Explorer", text_align = "center", saperator = true },
          { filetype = "aerial",   text = "Outline",  text_align = "center", saperator = true },
          { filetype = "Outline",  text = "Outline",  text_align = "center", saperator = true }, { filetype = "dbui", text = "Database Manager", text_align = "center", saperator = true },
          { filetype = "DiffviewFiles",       text = "Source Control",  text_align = "center", separator = true },
          { filetype = "httpResult",          text = "Http Result",     text_align = "center", saperator = true },
          { filetype = "OverseerList",        text = "Tasks",           text_align = "center", saperator = true },
          { filetype = "flutterToolsOutline", text = "Flutter Outline", text_align = "center", saperator = true },
        },
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count)
          return "(" .. count .. ")"
        end,
        show_duplicate_prefix = false,
        always_show_bufferline = vim.o.showtabline == 2,
        sort_by = "insert_after_current",
      },
    }
  end,
  keys = keys.bufferline,
}
