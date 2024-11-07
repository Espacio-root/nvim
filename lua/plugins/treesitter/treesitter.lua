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
      ensure_installed = "all",
      ignore_install = {"latex"},
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
    }
  end,
}
