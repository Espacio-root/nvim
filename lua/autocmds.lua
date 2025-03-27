local smallTabs = { "nix" }

--  change tab size
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        local filetype = vim.bo.filetype
        if vim.tbl_contains(smallTabs, filetype) then
            vim.o.tabstop = 2
            vim.o.shiftwidth = 2
        else
            vim.o.tabstop = 4
            vim.o.shiftwidth = 4
        end
    end,
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local FormatOptions = augroup("FormatOptions", { clear = true })
autocmd("BufEnter", {
    group = FormatOptions,
    pattern = "*",
    desc = "Set buffer local formatoptions.",
    callback = function()
        vim.opt_local.formatoptions:remove({
            "r", -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
            "o", -- Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
        })
    end,
})

-- Define a function to refocus Vim after focusing Zathura
local function tex_focus_vim()
    -- Pause briefly to allow the window manager to recognize the focus change
    vim.defer_fn(function()
        -- Refocus Vim using xdotool and the stored Vim window ID
        local window_id = vim.g.vim_window_id or ""
        if window_id ~= "" then
            os.execute("xdotool windowfocus " .. window_id)
            vim.cmd("redraw!") -- Redraw the screen
        else
            vim.notify("vim_window_id is not set", vim.log.levels.WARN)
        end
    end, 200) -- 200 ms delay
end

-- Create an autocommand group for Vimtex event focus
vim.api.nvim_create_augroup("vimtex_event_focus", { clear = true })

vim.api.nvim_create_autocmd("User", {
    group = "vimtex_event_focus",
    pattern = "VimtexEventView",
    callback = tex_focus_vim,
})

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.cpp",
    callback = function()
        local filename = vim.fn.expand("%")
        local output = vim.fn.expand("%:r") -- Get filename without extension
        local cmd = string.format("g++ -std=c++17 -Wall -Wextra -o %s %s", output, filename)
        -- vim.fn.jobstart(cmd, { on_stdout = function(_, data) print(table.concat(data, "\n")) end })
        vim.fn.jobstart(cmd)
    end,
})

-- Removing the initial empty buffer
local initial_dir_buf = nil

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local arg = vim.fn.argv(0)
        if arg == "" then return end

        local stat = vim.loop.fs_stat(arg)
        if stat then
            if stat.type == "directory" then
                vim.fn.chdir(arg)
                initial_dir_buf = vim.api.nvim_get_current_buf()

                vim.schedule(function()
                    require("fzf-lua").files()
                end)
            else
                local parent_dir = vim.fn.fnamemodify(arg, ":h")
                vim.fn.chdir(parent_dir)
            end
        end
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if initial_dir_buf and vim.api.nvim_buf_is_valid(initial_dir_buf) then
            local dir_buf = initial_dir_buf -- Capture the buffer variable
            initial_dir_buf = nil -- Prevent re-executing this logic

            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(dir_buf) then
                    vim.cmd("bd " .. dir_buf) -- Close the directory buffer safely
                end
            end)
        end
    end,
})
