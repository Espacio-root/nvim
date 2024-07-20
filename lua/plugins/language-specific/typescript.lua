local handler = require("lsp-handler")
local augroup = vim.api.nvim_create_augroup("TypescriptAutoImport", {})

return {
    "jose-elias-alvarez/typescript.nvim",
    opts = {
        disable_commands = false, -- prevent the plugin from creating Vim commands
        debug = false, -- enable debug logging for commands
        go_to_source_definition = {
            fallback = true, -- fall back to standard LSP definition on failure
        },
        server = { -- pass options to lspconfig's setup method
            on_attach = handler.on_attach,
            capabilities = handler.capabilities,
        },
    }
}
