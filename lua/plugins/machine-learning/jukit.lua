local keys = require("keymaps")

local filetypes = {"python", "ipynb", "rs", "json"}

return {
    'luk400/vim-jukit',
    ft = filetypes,
    -- cmd = {"Jukit"},
    keys = keys.jukit
}
