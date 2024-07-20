return {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    -- local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup({
      debug = false,
      sources = {
        formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
        formatting.black.with({ extra_args = { "--fast" } }),
        formatting.stylua.with({ args = { "--config", "{indent_width=2}" } }),
        -- diagnostics.flake8
      },
    })
  end,
}
