local keys = require("keymaps")

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local servers = require("helper").servers

    -- Set up LspAttach autocommand for keymaps (replaces on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(args)
        local bufnr = args.buf
        keys.lsp_keymaps(bufnr)
      end,
    })

    -- Configure capabilities for nvim-cmp
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

    -- Configure Arduino Language Server
    -- local arduino_caps = vim.tbl_deep_extend("force", {}, capabilities)
    -- arduino_caps.offsetEncoding = { "utf-16" }
    vim.lsp.config("arduino_language_server", {
      cmd = {
        "arduino-language-server",
        "-cli-config", "/home/espacio/.arduino15/arduino-cli.yaml",
        "-cli", "/usr/bin/arduino-cli",
        "-fqbn", "esp32:esp32:esp32",
        "-clangd", "/usr/bin/clangd"
      },
      init_options = {
        clangdArgs = {
          "--query-driver=**"  -- Allows clangd to read any compiler's paths
        }
      },
      capabilities = capabilities,
      root_dir = vim.fs.root(0, { "*.ino" }),
    })

    -- Configure all servers from helper.servers
    for _, server in pairs(servers) do
      local opts = {
        capabilities = capabilities
      }

      server = vim.split(server, '@')[1]
      
      -- Load server-specific configuration if it exists
      local require_ok, conf_opts = pcall(require, "plugins.lsp.servers." .. server)
      if require_ok then
        opts = vim.tbl_deep_extend("force", opts, conf_opts)
      end

      vim.lsp.config(server, opts)
    end

    -- Enable all configured servers
    local server_names = {}
    table.insert(server_names, "arduino_language_server")
    for _, server in pairs(servers) do
      table.insert(server_names, vim.split(server, '@')[1])
    end
    
    vim.lsp.enable(server_names)
  end
}
