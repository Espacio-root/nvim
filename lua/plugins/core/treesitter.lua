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
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "bash", "cpp", "gitignore", "html", "css", "javascript", "typescript", "python", "rust"},
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
