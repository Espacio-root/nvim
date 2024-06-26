local custom = require "customization"

return {
  "Bekaboo/dropbar.nvim",
  enabled = true,
  event = {
    "BufRead",
    "BufNewFile",
  },
  opts = {
    icons = {
      kinds = {
        symbols = custom.icons.kind_with_space,
      },
    },
    sources = {
      path = {
        modified = function(sym)
          return sym:merge {
            name = sym.name .. " [+]",
            name_hl = "DiffAdded",
          }
        end,
      },
    },
  },
  keys = {
    { "<leader>bp", function() require('dropbar.api').pick() end, mode="n", desc="Pick a dropdown" }
  }
}
