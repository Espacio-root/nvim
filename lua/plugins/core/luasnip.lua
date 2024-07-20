local untrigger = function()
  -- get the snippet
  local snip = require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()].parent.snippet
  -- get its trigger
  local trig = snip.trigger
  -- replace that region with the trigger
  local node_from, node_to = snip.mark:pos_begin_end_raw()
  vim.api.nvim_buf_set_text(
    0,
    node_from[1],
    node_from[2],
    node_to[1],
    node_to[2],
    { trig }
  )
  -- reset the cursor-position to ahead the trigger
  vim.fn.setpos(".", { 0, node_from[1] + 1, node_from[2] + 1 + string.len(trig) })
end

return {
  "L3MON4D3/LuaSnip",
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
  dependencies = {
    { "rafamadriz/friendly-snippets" },
  },
  build = "make install_jsregexp",
  config = function()
    local snip = require "luasnip"
    local types = require "luasnip.util.types"

    local i = snip.insert_node
    local sn = snip.snippet_node

    snip.setup {
      update_events = { "TextChanged", "TextChangedI" },
      enable_autosnippets = true,
      delete_check_events = "TextChanged",
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
        -- Same with text node, used for function nodes
        text_same_with = function(args)
          return args[1][1]
        end,

        -- Same with text node, used for dynamic nodes
        insert_same_with = function(args)
          return sn(nil, {
            i(1, args[1][1]),
          })
        end,

        insert_same_with_last_path = function(args)
          local text = args[1][1]
          text = text:match "([^/]+)$"
          return sn(nil, {
            i(1, text),
          })
        end,

        -- Same with text node but append text, used for function nodes
        text_same_with_and_append = function(args, _, user_arg1)
          return args[1][1] .. user_arg1
        end,

        -- Same with text node but append text, used for dynamic nodes
        insert_same_with_and_append = function(args, _, _, user_arg1)
          return sn(nil, {
            i(1, args[1][1] .. user_arg1),
          })
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
      },
    }

    snip.filetype_extend("cpp", { "c" })

    snip.filetype_extend("javascriptreact", { "javascript" })
    snip.filetype_extend("typescript", { "javascript" })
    snip.filetype_extend("typescriptreact", { "javascript" })

    snip.filetype_extend("typescriptreact", { "javascriptreact" })

    require("luasnip.loaders.from_lua").lazy_load {
      paths = vim.fn.stdpath "config" .. "/lua/snippets",
    }
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
  keys = {
    { "<C-n>", "<Plug>luasnip-next-choice", mode = {"i", "s"} },
    { "<C-p>", "<Plug>luasnip-prev-choice", mode = {"i", "s"} },
    { "<C-x>", function()
        if require("luasnip").in_snippet() then
          untrigger()
          require("luasnip").unlink_current()
        end
    end, desc = "Undo a snippet", mode = {"i", "s"} }
  }
}
