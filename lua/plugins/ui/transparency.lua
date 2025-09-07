return {
    "xiyaowong/transparent.nvim",
    config = function()
        require("transparent").setup({
            groups = {
                'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
                'EndOfBuffer',
            },
            extra_groups = {
                'NormalFloat', 'FloatBorder', 'FloatShadow', 'FloatShadowThrough',
                -- Adding more status line related groups
                'StatusLineTerm', 'StatusLineTermNC',
                'TabLine', 'TabLineFill', 'TabLineSel',
                'VertSplit',  -- if you want transparent window separators
            },
            exclude_groups = {},
            on_clear = function() end,
        })
    end
}
