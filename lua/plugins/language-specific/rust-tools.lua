local handler = require('lsp-handler')

return {
    'simrat39/rust-tools.nvim',
    enabled = false,
    opts = {
        server = {
            on_attach = handler.on_attach,
            capabilities = handler.capabilities,
        }
    }
}
