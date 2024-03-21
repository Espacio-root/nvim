local custom = require "customization"

require "options"
require "keymaps"
require "autocmds"
require "lsp"
require "manager"

vim.cmd.colorscheme(custom.theme)
