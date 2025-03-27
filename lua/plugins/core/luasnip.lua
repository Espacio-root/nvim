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
  dependencies = { "rafamadriz/friendly-snippets" },

  config = function()
    local snip = require "luasnip"
    local types = require "luasnip.util.types"

    local i = snip.insert_node
    local sn = snip.snippet_node

    snip.setup({
      update_events = { "TextChanged", "TextChangedI", "InsertLeave" },
      enable_autosnippets = vim.bo.filetype == "tex",
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
      snip_env = {
        text_same_with = function(args)
          return args[1][1]
        end,

        insert_copy_from_clipboard = function()
          local reg = vim.fn.getreg "+"
          local text = {}
          for line in reg:gmatch "[^\n]+" do
            table.insert(text, line)
          end
          return sn(nil, {
            i(1, text),
          })
        end,
      }
    })

    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load {
      paths = vim.fn.stdpath "config" .. "/lua/snippets",
    }
  end,
  keys = keys.luaSnip,

}
