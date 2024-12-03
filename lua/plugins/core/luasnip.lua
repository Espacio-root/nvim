local keys = require("keymaps")

return {
  "L3MON4D3/LuaSnip",
  event = {
    "InsertEnter", "CmdlineEnter",
  },
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  dependencies = {"rafamadriz/friendly-snippets"},

  config = function()
    local snip = require "luasnip"
    local types = require "luasnip.util.types"
    snip.setup({
      update_events = { "TextChanged", "TextChangedI", "InsertLeave" },
      -- enable_autosnippets = true,
      delete_check_events = { "TextChanged", "InsertLeave" },
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "●", "Operator" } },
            virt_text_pos = "inline",
          },
          unvisited = {
            virt_text = { { "●", "Comment" } },
            virt_text_pos = "inline",
          },
        },
        [types.insertNode] = {
          active = {
            virt_text = { { "●", "Keyword" } },
            virt_text_pos = "inline",
          },
          unvisited = {
            virt_text = { { "●", "Comment" } },
            virt_text_pos = "inline",
          },
        },
      },
    })

    require("luasnip.loaders.from_vscode").lazy_load()
  end,
  keys = keys.luaSnip,

}
