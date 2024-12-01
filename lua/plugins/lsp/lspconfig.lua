local keys = require("keymaps")

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local servers = {
            "lua_ls",
            "pyright",
            "html",
            "cssls",
            "bashls",
            "jsonls",
            "yamlls",
            "tailwindcss",
            "rust_analyzer",
            "clangd",
            "jdtls",
            "arduino_language_server"
        }

        local on_attach = function(client, bufnr)
            keys.lsp_keymaps(bufnr)
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

        for _,server in pairs(servers) do
            opts = {
                on_attach = on_attach,
                capabilities = capabilities
            }

            server = vim.split(server, '@')[1]
            local require_ok, conf_opts = pcall(require, "plugins.lsp.servers." .. server)
            if (require_ok) then
                opts = vim.tbl_deep_extend("force", opts, conf_opts)
            end

            lspconfig[server].setup(opts);

        end
    end
}
