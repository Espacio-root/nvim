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

return {
    'luk400/vim-jukit',
    lazy = true,
    ft = {"python", "ipynb", "rs", "json"},
    -- config = function()
    --     vim.g.jukit_shell_cmd = 'evcxr_jupyter'
    -- end,
    keys = {
        { "<leader>os", function() execute_with_venv("JukitOut conda activate ", "call jukit#splits#output()") end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>ohs", function() execute_with_venv("JukitOutHist conda activate ", "call jukit#splits#output_and_history()") end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>hs", function() vim.cmd('call jukit#splits#history()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>hd", function() vim.cmd('call jukit#splits#close_history()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>od", function() vim.cmd('call jukit#splits#close_output_split()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>ohd", function() vim.cmd('call jukit#splits#close_output_and_history(1)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>so", function() vim.cmd('call jukit#splits#show_last_cell_output(1)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>j", function() vim.cmd('call jukit#splits#out_hist_scroll(1)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>k", function() vim.cmd('call jukit#splits#out_hist_scroll(0)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>ah", function() vim.cmd('call jukit#splits#toggle_auto_hist()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>sl", function() vim.cmd('call jukit#layouts#set_layout()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader><space>", function() vim.cmd('call jukit#send#section(0)') end, { noremap = true, silent = true, mode = "n" } },
        { "<cr>", function() vim.cmd('call jukit#send#line()') end, { noremap = true, silent = true, mode = "n" } },
        { "<cr>", function() vim.cmd('call jukit#send#selection()') end, { noremap = true, silent = true, mode = "v" } },
        { "<leader>cc", function() vim.cmd('call jukit#send#until_current_section()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>all", function() vim.cmd('call jukit#send#all()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>co", function() vim.cmd('call jukit#cells#create_below(0)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>cO", function() vim.cmd('call jukit#cells#create_above(0)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>ct", function() vim.cmd('call jukit#cells#create_below(1)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>cT", function() vim.cmd('call jukit#cells#create_above(1)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>cd", function() vim.cmd('call jukit#cells#delete()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>cs", function() vim.cmd('call jukit#cells#split()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>cM", function() vim.cmd('call jukit#cells#merge_above()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>cm", function() vim.cmd('call jukit#cells#merge_below()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>ck", function() vim.cmd('call jukit#cells#move_up()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>cj", function() vim.cmd('call jukit#cells#move_down()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>J", function() vim.cmd('call jukit#cells#jump_to_next_cell()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>K", function() vim.cmd('call jukit#cells#jump_to_previous_cell()') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>ddo", function() vim.cmd('call jukit#cells#delete_outputs(0)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>dda", function() vim.cmd('call jukit#cells#delete_outputs(1)') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>np", function() vim.cmd('call jukit#convert#notebook_convert("jupyter-notebook")') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>ht", function() vim.cmd('call jukit#convert#save_nb_to_file(0,1,"html")') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>rht", function() vim.cmd('call jukit#convert#save_nb_to_file(1,1,"html")') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>pd", function() vim.cmd('call jukit#convert#save_nb_to_file(0,1,"pdf")') end, { noremap = true, silent = true, mode = "n" } },
        { "<leader>rpd", function() vim.cmd('call jukit#convert#save_nb_to_file(1,1,"pdf")') end, { noremap = true, silent = true, mode = "n" } },
    }
}
