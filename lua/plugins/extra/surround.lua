return {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            surrounds = {
                ["("] = false,
                ["["] = false,
                ["{"] = false,
                ["'"] = false,
                ['"'] = false,
                ["`"] = false,
            },
            aliases = {
                ["("] = ")",
                ["["] = "]",
                ["{"] = "}",
                ["'"] = "'",
                ['"'] = '"',
                ["`"] = "`",
            },
        })
    end
}
