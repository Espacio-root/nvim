local M = {}

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- x copies to 0th register
vim.keymap.set({ "n", "v" }, "x", "\"0x", { noremap = true })
vim.keymap.set({ "n", "v" }, "X", "\"0X", { noremap = true })

-- global copy/pastes
vim.keymap.set({ "n", "v" }, "gy", "\"+y", { noremap = true })
vim.keymap.set({ "n", "v" }, "gp", "\"+p", { noremap = true })

-- pastes don't overwrite default register
vim.keymap.set({ "n", "v" }, "p", '"0p', { noremap = true }) -- for pasting after cursor
vim.keymap.set({ "n", "v" }, "P", '"0P', { noremap = true }) -- for pasting before cursor

-- move through windows
vim.keymap.set("n", "<C-h>", function() vim.cmd("wincmd h") end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", function() vim.cmd("wincmd l") end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", function() vim.cmd("wincmd j") end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", function() vim.cmd("wincmd k") end, { noremap = true, silent = true })

M.lsp_keymaps = function(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap

  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)                   -- Go to definition
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)                  -- Go to declaration
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)               -- Go to implementation
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)                   -- Find references

  keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)                 -- Go to previous diagnostic
  keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)                 -- Go to next diagnostic

  keymap(bufnr, "n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)        -- Show diagnostics in float
  keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)          -- Code actions
  keymap(bufnr, "n", "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)               -- Rename symbol
  keymap(bufnr, "n", "<leader>lh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)       -- Show signature help
  keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<CR>", opts) -- Format buffer
  keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<CR>", opts)                                -- Show LSP info
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)                         -- Show hover docs
end

M.files = {
  { "<leader>e", function() require("mini.files").open() end, mode = { "n", "v" }, desc = "file tree" }
}

M.luaSnip = {
  { "<C-n>", "<Plug>luasnip-next-choice", mode = { "i", "s" } },
  { "<C-p>", "<Plug>luasnip-prev-choice", mode = { "i", "s" } },
  {
    "<C-x>",
    function()
      if require("luasnip").in_snippet() then
        untrigger()
        require("luasnip").unlink_current()
      end
    end,
    desc = "Undo a snippet",
    mode = { "i", "s" }
  }
}

M.fzf = {
  { "<leader>ff",  function() require("fzf-lua").files() end,                 desc = "Files", },
  { "<leader>fb",  function() require("fzf-lua").buffers() end,               desc = "Buffers", },
  { "<leader>f?",  function() require("fzf-lua").help_tags() end,             desc = "Help tags", },
  { "<leader>fh",  function() require("fzf-lua").oldfiles() end,              desc = "Old files", },
  { "<leader>fm",  function() require("fzf-lua").marks() end,                 desc = "Marks", },
  { "<leader>fs",  function() require("fzf-lua").lsp_document_symbols() end,  desc = "Symbols", },
  { "<leader>fS",  function() require("fzf-lua").lsp_workspace_symbols() end, desc = "Symbols", },
  { "<leader>fc",  function() require("fzf-lua").colorschemes() end,          desc = "Colorscheme", },
  { "<leader>fH",  function() require("fzf-lua").highlights() end,            desc = "Highlights", },
  { "<leader>fj",  function() require("fzf-lua").jump() end,                  desc = "Jumplist", },
  { "<leader>fw",  function() require("fzf-lua").live_grep_native() end,      desc = "Live grep", },

  -- git
  { "<leader>fgc", function() require("fzf-lua").git_commits() end,           desc = "Commits", },
  { "<leader>fgb", function() require("fzf-lua").git_branchs() end,           desc = "Branchs", },
  { "<leader>fgt", function() require("fzf-lua").git_tags() end,              desc = "Tags", },
}

M.bufferline = {
  { "<M-1>",       "<Cmd>BufferLineGoToBuffer 1<CR>",    desc = "Go to buffer 1" },
  { "<M-2>",       "<Cmd>BufferLineGoToBuffer 2<CR>",    desc = "Go to buffer 2" },
  { "<M-3>",       "<Cmd>BufferLineGoToBuffer 3<CR>",    desc = "Go to buffer 3" },
  { "<M-4>",       "<Cmd>BufferLineGoToBuffer 4<CR>",    desc = "Go to buffer 4" },
  { "<M-5>",       "<Cmd>BufferLineGoToBuffer 5<CR>",    desc = "Go to buffer 5" },
  { "<M-6>",       "<Cmd>BufferLineGoToBuffer 6<CR>",    desc = "Go to buffer 6" },
  { "<M-7>",       "<Cmd>BufferLineGoToBuffer 7<CR>",    desc = "Go to buffer 7" },
  { "<M-8>",       "<Cmd>BufferLineGoToBuffer 8<CR>",    desc = "Go to buffer 8" },
  { "<M-9>",       "<Cmd>BufferLineGoToBuffer 9<CR>",    desc = "Go to buffer 9" },

  { "<M-S-l>",     "<Cmd>BufferLineMoveNext<CR>",        desc = "Move buffer to next" },
  { "<M-S-h>",     "<Cmd>BufferLineMovePrev<CR>",        desc = "Move buffer to previous" },

  { "<S-h>",       "<Cmd>BufferLineCyclePrev<CR>",       desc = "Move to previous buffer" },
  { "<S-l>",       "<Cmd>BufferLineCycleNext<CR>",       desc = "Move to next buffer" },

  { "<leader>bc",  "<cmd>BufferLinePickClose<CR>",       desc = "Close" },
  { "<leader>bw",  "<cmd>BufferLineCloseOthers<CR>",     desc = "Close" },
  { "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", desc = "By extension" },
  { "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", desc = "By directory" },
  { "<leader>bst", "<cmd>BufferLineSortByTabs<CR>",      desc = "By tabs" },
}

local execute_with_venv = function(default_cmd, fallback_cmd)
  local venv = require('venv-selector').get_active_venv()
  if venv == nil then
    vim.cmd(fallback_cmd)
  else
    local venv_parts = vim.split(venv, "/")
    local venv_name = venv_parts[#venv_parts]
    vim.cmd(default_cmd .. venv_name)
  end
end

M.jukit = {
  { "<leader>os",  function() execute_with_venv("JukitOut conda activate ", "call jukit#splits#output()") end,                 noremap = true, mode = "n",    ft = filetypes },
  { "<leader>ohs", function() execute_with_venv("JukitOutHist conda activate ", "call jukit#splits#output_and_history()") end, noremap = true, silent = true, mode = "n",    ft = filetypes },
}

M.undotree = {
  { "<leader>u", vim.cmd.UndotreeToggle, mode = { "n", "v" }, desc = "toggle undotree" }
}


return M
