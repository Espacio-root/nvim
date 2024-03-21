return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")
    local handler = require("lsp-handler")
    local servers = handler.servers
    local on_attach = handler.on_attach
    local capabilities = handler.capabilities
    local opts = {}

    for _, server in pairs(servers) do
      opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }

      server = vim.split(server, "@")[1]

      local require_ok, conf_opts = pcall(require, "plugins.lsp.servers." .. server)
      if require_ok then
        opts = vim.tbl_deep_extend("force", conf_opts, opts)
      end

      lspconfig[server].setup(opts)
    end
  end,
}
