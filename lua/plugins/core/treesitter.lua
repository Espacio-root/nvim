local max_filesize = 100 * 1024 -- 100 KB

--- Check if treesitter should be disabled for a buffer (large files).
local function is_large_file(buf)
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
  return ok and stats and stats.size > max_filesize
end

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- The new nvim-treesitter only handles parser installation.
    -- Highlight, indent, etc. are now built into Neovim core.
    require("nvim-treesitter").setup()

    -- Auto-install parsers on FileType
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Auto-install treesitter parser for filetype",
      callback = function(ev)
        if is_large_file(ev.buf) then
          return
        end
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang and not pcall(vim.treesitter.language.inspect, lang) then
          require("nvim-treesitter").install({ lang })
        end
      end,
    })

    -- Enable treesitter highlighting and indentation for all filetypes,
    -- skipping large files.
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Enable treesitter highlighting and indentation",
      callback = function(ev)
        if is_large_file(ev.buf) then
          return
        end
        -- Enable highlighting (replaces the old highlight = { enable = true })
        pcall(vim.treesitter.start, ev.buf)
        -- Enable indentation (replaces the old indent = { enable = true })
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
