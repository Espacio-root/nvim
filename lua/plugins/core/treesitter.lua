local function disable_treesitter(lang, buf)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  commit = "3826d0c42ac635f560479b5b6ab522f6627a3466",
  config = function()
    require("nvim-treesitter.configs").setup {
      -- ensure_installed = { "python", "c", "cpp", "lua", "javascript", "typescript", "html", "css" },
      ensured_installed = "all",
      ignore_install = { "latex", "systemverilog" },
      sync_install = false,
      auto_install = true,

      highlight = {
        enable = true,
        disable = disable_treesitter,
      },

      indent = {
        enable = true,
        disable = disable_treesitter,
      },

      endwise = {
        enable = true,
        disable = disable_treesitter,
      },

      pairs = {
        enable = true,
        disable = {},
        highlight_pair_events = { "CursorMoved", "ModeChanged" },
        highlight_self = false,                                       -- whether to highlight also the part of the pair under cursor (or only the partner)
        goto_right_end = false,                                       -- whether to go to the end of the right partner or the beginning
        fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')", -- What command to issue when we can't find a pair (e.g. "normal! %")
        keymaps = {
          goto_partner = "<leader>%",
          delete_balanced = "X",
        },
        delete_balanced = {
          only_on_first_char = false, -- whether to trigger balanced delete when on first character of a pair
          fallback_cmd_normal = nil,  -- fallback command when no pair found, can be nil
          longest_partner = false,    -- whether to delete the longest or the shortest pair when multiple found.
          -- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
        }
      }

    }
  end,
}
