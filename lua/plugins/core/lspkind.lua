local custom = require "customization"

return {
  "onsails/lspkind.nvim",
  lazy = true,
  config = function()
    require("lspkind").init {
      symbol_map = custom.icons.kind,
    }
  end,
}
