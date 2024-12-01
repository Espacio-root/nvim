return {
    settings = {

        Lua = {
            diagnostics = {
                globals = { "vim" },
                disable = { "undefined-global" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
}
