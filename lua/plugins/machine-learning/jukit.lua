local keys = require("keymaps")

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

local filetypes = {"python", "ipynb", "rs", "json"}

return {
    'luk400/vim-jukit',
    ft = filetypes,
    keys = keys.jukit
}
