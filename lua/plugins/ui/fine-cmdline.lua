local custom = require("customization")

return {
  'VonHeikemen/fine-cmdline.nvim',
  enabled = false,
  dependencies = {
    'MunifTanjim/nui.nvim'
  },
  opts = {
    cmdline = {
      enable_keymaps = true,
      smart_history = true,
      prompt = ': '
    },
    popup = {
      position = {
        row = '10%',
        col = '50%',
      },
      size = {
        width = '60%',
      },
      border = {
        style = custom.border,
      },
      win_options = {
        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
      },
    },
  },
  keys = {
    -- {
    --   '<CR>',
    --   '<cmd>FineCmdline<CR>',
    --   mode='n',
    --   silent=true,
    --   noremap=true,
    -- },
    {
      ':',
      '<cmd>FineCmdline<CR>',
      mode='n',
      silent=true,
      noremap=true,
    }
  }
}
