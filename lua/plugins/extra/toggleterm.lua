local custom = require "customization"

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  -- config = function()
    -- local group = vim.api.nvim_create_augroup('toggleterm', {})
    -- vim.api.nvim_create_autocmd("BufEnter", {
    --   group=group,
    --   desc="Set C-k to move up in both normal and insert mode",
    --   callback = function()
    --     local bufnr = vim.api.nvim_get_current_buf()
    --     if string.find(vim.api.nvim_buf_get_name(bufnr), "toggleterm") then
    --       vim.keymap.set({"n", "i"}, "<C-k>", function() vim.cmd("wincmd k") end, { noremap = true, silent = true })
    --     end
    --   end
    -- })

    -- vim.api.nvim_create_autocmd("BufLeave", {
    --   group=group,
    --   desc="Set C-k to move up in both normal and insert mode",
    --   callback = function()
    --     local bufnr = vim.api.nvim_get_current_buf()
    --     if string.find(vim.api.nvim_buf_get_name(bufnr), "toggleterm") then
    --       vim.keymap.set("n", "<C-k>", function() vim.cmd("wincmd k") end, { noremap = true, silent = true })
    --     end
    --   end
    -- })
  -- end,
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return vim.api.nvim_get_option("lines") * 0.25
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.25
      end
    end,
    open_mapping = [[<c-\>]],
    on_create = function(t)
      local bufnr = t.bufnr
      vim.keymap.set("t", "<Esc>", "<C-\\><C-N>", { buffer = bufnr })
    end,
    shell = vim.uv.os_uname().sysname == "Windows_NT" and "pwsh" or custom.shell,
    float_opts = {
      border = custom.border,
    },
    winbar = {
      enabled = true,
    },
  },
  keys = function()
    local float_opts = {
      border = custom.border,
    }

    -- local lazygit = require("toggleterm.terminal").Terminal:new {
    --   cmd = "lazygit",
    --   hidden = true,
    --   direction = "float",
    --   float_opts = float_opts,
    -- }
    local lazydocker = require("toggleterm.terminal").Terminal:new {
      cmd = "lazydocker",
      hidden = true,
      direction = "float",
      float_opts = float_opts,
    }
    local gh_dash = require("toggleterm.terminal").Terminal:new {
      -- https://github.com/dlvhdr/gh-dash/issues/316
      env = { LANG = "en_US.UTF-8" },
      cmd = "gh-dash",
      hidden = true,
      direction = "float",
      float_opts = float_opts,
    }
    local lf = require("toggleterm.terminal").Terminal:new {
      cmd = "lf",
      hidden = true,
      direction = "float",
      float_opts = float_opts,
    }

    return {
      { "<C-\\>" },
      { "<leader>tt", "<Cmd>ToggleTermToggleAll<CR>", mode = "n", desc = "All Terminal" },

      -- External programs
      {
        "<leader>pd",
        function()
          lazydocker:toggle()
        end,
        desc = "Lazy Docker",
      },
      {
        "<leader>pg",
        function()
          gh_dash:toggle()
        end,
        desc = "GitHub Dash",
      },
      {
        "<leader>n",
        function()
          lf:toggle()
        end,
        desc = "File Navigator",
      },
    }
  end,
}
