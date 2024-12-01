local keys = require("keymaps")

return {
  "echasnovski/mini.files",
  version = false,
  config = function() require("mini.files").setup() end,
  keys = keys.files,
}
