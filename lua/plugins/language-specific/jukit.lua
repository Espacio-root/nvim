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
    keys = {
        { "<leader>os", function() execute_with_venv("JukitOut conda activate ", "call jukit#splits#output()") end, noremap = true, mode = "n", ft=filetypes  },
        { "<leader>ohs", function() execute_with_venv("JukitOutHist conda activate ", "call jukit#splits#output_and_history()") end, noremap = true, silent = true, mode = "n", ft=filetypes },
    }
}
