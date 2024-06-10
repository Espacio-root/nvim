return {
    "vimwiki/vimwiki",
    lazy = true,
    init = function()
        vim.g.vimwiki_list = {
            {
                path = '~/wiki',
                syntax = 'default',
                ext = '.wiki',
            },
        }
    end,
}
