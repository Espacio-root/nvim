local i = require("icons")

return {
  "onsails/lspkind.nvim",
  lazy = true,
  config = function()
    require("lspkind").init {
      symbol_map = i.icons.kind,
    }
  end,
}
