local custom = require "customization"
local virtual_text = false

-- Set diagnostic options
vim.diagnostic.config {
  virtual_text = false,
  float = {
    severity_sort = true,
    source = "if_many",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = custom.icons.diagnostic.error,
      [vim.diagnostic.severity.WARN] = custom.icons.diagnostic.warn,
      [vim.diagnostic.severity.HINT] = custom.icons.diagnostic.hint,
      [vim.diagnostic.severity.INFO] = custom.icons.diagnostic.info,
    },
  },
}
local setVirtualText = function()
  if not virtual_text then
    vim.diagnostic.config {
      virtual_text = {
        spacing = 4,
        prefix = "●",
        severity = vim.diagnostic.severity.ERROR
      }
    }
    virtual_text = true
  end
end

local unsetVirtualtext = function()
  if virtual_text then
    vim.diagnostic.config {
      virtual_text = false
    }
    virtual_text = false
  end
end

local group = vim.api.nvim_create_augroup("lspgroup", {})
vim.api.nvim_create_autocmd("TextChanged", {
  desc = "Unset virtual_text upon buffer modification",
  group = group,
  callback = function()
    unsetVirtualtext()
  end
})

vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
  group = group,
  desc = "Set virtual_text upon buffer modification",
  callback = function()
    setVirtualText()
  end
})

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or custom.border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
