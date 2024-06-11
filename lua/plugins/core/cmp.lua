local custom = require "customization"

return {
  "hrsh7th/nvim-cmp",
  event = {
    "InsertEnter",
    "CmdlineEnter",
  },
  dependencies = {
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-calc" },
    { "quangnguyen30192/cmp-nvim-ultisnips" },
    { "kristijanhusak/vim-dadbod-completion" },
    { "lukas-reineke/cmp-under-comparator" },
  },
  config = function()
    local cmp = require "cmp"
    local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
    local lspkind = require "lspkind"

    cmp.setup {
      window = {
        completion = {
          border = custom.border,
          col_offset = -3,
        },
        documentation = {
          border = custom.border,
        },
      },
      snippet = {
        expand = function(args)
          vim.fn["UltiSnips#Anon"](args.body)
        end,
      },
      mapping = {
        ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<M-n>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<M-p>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping {
          i = cmp.mapping.close(),
          c = cmp.mapping.close(),
        },
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(
          function(fallback)
            cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
          end, {"i", "s", "c"}),
        ["<S-Tab>"] = cmp.mapping(
          function(fallback)
            cmp_ultisnips_mappings.jump_backwards(fallback)
          end, { "i", "s", "c" }
        )},
      sources = {
        { name = "nvim_lsp" },
        { name = "ultisnips" },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
        { name = "path" },
        { name = "calc" },
        { name = "orgmode" },
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = "symbol",
          maxwidth = 50,
          menu = {
            ultisnip = "[SNP]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[VIM]",
            buffer = "[BUF]",
            path = "[PTH]",
            calc = "[CLC]",
            latex_symbols = "[TEX]",
            orgmode = "[ORG]",
          },
          before = require("tailwindcss-colorizer-cmp").formatter,
        },
        -- format = custom_formatter,
        fields = {
          "kind",
          "abbr",
          "menu",
        },
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require("cmp-under-comparator").under,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
    }

    cmp.setup.cmdline(":", {
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    cmp.setup.cmdline("/", {
      sources = {
        { name = "buffer" },
      },
    })

    vim.api.nvim_create_autocmd("BufRead", {
      desc = "Setup cmp buffer crates source",
      pattern = "Cargo.toml",
      callback = function()
        cmp.setup.buffer {
          sources = {
            { name = "crates" },
          },
        }
      end,
    })
    vim.api.nvim_create_autocmd("Filetype", {
      desc = "Setup cmp buffer sql source",
      pattern = "sql",
      callback = function()
        cmp.setup.buffer {
          sources = {
            { name = "vim-dadbod-completion" },
          },
        }
      end,
    })
  end,
}
