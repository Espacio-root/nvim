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
    { "saadparwaiz1/cmp_luasnip" },
    { "kristijanhusak/vim-dadbod-completion" },
    { "lukas-reineke/cmp-under-comparator" },
  },
  config = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"
    local lspkind = require "lspkind"
    local tailwind_formatter = require("tailwindcss-colorizer-cmp").formatter

    local function custom_formatter(entry, vim_item)
      local lspkind_formatted = lspkind.cmp_format {
        mode = "symbol",
        maxwidth = 50,
        menu = {
          luasnip = "[SNP]",
          nvim_lsp = "[LSP]",
          nvim_lua = "[VIM]",
          buffer = "[BUF]",
          path = "[PTH]",
          calc = "[CLC]",
          latex_symbols = "[TEX]",
          orgmode = "[ORG]",
        },
      }(entry, vim_item)

      local tailwind_formatted = tailwind_formatter(entry, vim_item)

      -- Merge the two formatted results
      return vim.tbl_extend('keep', lspkind_formatted, tailwind_formatted)
    end

    -- local has_words_before = function()
    --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
    -- end

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
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping {
          i = cmp.mapping.close(),
          c = cmp.mapping.close(),
        },
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<C-n>"] = cmp.mapping(function(fallback)
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          elseif cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, {
          "i",
          "s",
          "c",
        }),

        ["<C-p>"] = cmp.mapping(function(fallback)
          if luasnip.choice_active() then
            luasnip.change_choice(-1)
          elseif cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, {
          "i",
          "s",
          "c",
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif cmp.visible() then
            cmp.select_next_item()
          -- elseif has_words_before() then
          --   cmp.complete()
          else
            fallback() --Fallback to tabout of `ultimate-autopair` as expected
          end
        end, {
          "i",
          "s",
          "c",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          elseif cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, {
          "i",
          "s",
          "c",
        }),
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        {
          name = "buffer",
          option = {
            get_bufnrs = function()
              if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype") == "tex" then
                return {}
              end
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
            luasnip = "[SNP]",
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
