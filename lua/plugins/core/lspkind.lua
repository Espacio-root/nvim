local i = require("icons")

return {
  "onsails/lspkind.nvim",
  lazy = true,
  config = function()
    require("lspkind").init {
      mode = 'symbol_text',
      preset = 'codicons',
      symbol_map = i.icons.kind,
    }
  end,
}
