-- General
-- vim.opt.clipboard:append("unnamedplus")
vim.opt.exrc = true

-- Edit
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.includeexpr = "substitute(v:fname,'\\.','/','g')"
-- vim.opt.jumpoptions = "stack"
-- vim.opt.paste = true

-- Interface
vim.opt.confirm = true
vim.opt.splitkeep = "screen"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.number = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.mouse = "a"
vim.opt.mousemoveevent = true
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.conceallevel = 2
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 5
-- vim.opt.smoothscroll = true
vim.opt.pumblend = 12
vim.opt.pumheight = 12
vim.opt.guifont = "Cascadia Code PL:h14"
vim.opt.shortmess:append "I"
vim.opt.fillchars = {
  eob = " ",
  diff = "╱",
  foldopen = "",
  foldclose = "",
  foldsep = "▕",
}

-- Jukit
-- vim.g.jukit_mappings = 0
vim.g.jukit_output_new_os_window = 1
vim.g.jukit_outhist_new_os_window = 1
vim.g.jukit_convert_open_default = 0
vim.g.jukit_shell_cmd = 'nix-shell ~/mlearning/shell.nix --run \'ipython3'
-- vim.g.jukit_terminal = "nvimterm"
