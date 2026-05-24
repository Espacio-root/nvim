local max_filesize = 100 * 1024 -- 100 KB

--- Check if treesitter should be disabled for a buffer (large files).
local function is_large_file(buf)
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
  return ok and stats and stats.size > max_filesize
end

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate'
}
