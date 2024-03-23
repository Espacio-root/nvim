return {
  'VonHeikemen/fine-cmdline.nvim',
  enabled = false,
  dependencies = {
    'MunifTanjim/nui.nvim'
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
