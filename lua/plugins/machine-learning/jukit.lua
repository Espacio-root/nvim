local keys = require("keymaps")

local filetypes = {"python", "ipynb", "rs", "json"}

return {
    'luk400/vim-jukit',
    ft = filetypes,
    keys = keys.jukit
}
