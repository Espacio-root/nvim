return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup({
      debug = false,
      sources = {
        formatting.prettierd.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
        formatting.black.with({ extra_args = { "--fast" } }),
        formatting.stylua.with({
          args = { "--indent-width", "2", "--indent-type", "Spaces" },
        }),
        formatting.clang_format,
        -- diagnostics.eslint.with({
        --     filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
        -- }),
        -- diagnostics.flake8,
      },
    })
  end,
}
