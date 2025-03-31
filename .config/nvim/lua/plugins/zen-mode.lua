return {
    "folke/zen-mode.nvim",
    opts = {
        window = {
            backdrop = 1,
            width = 100,
        },
        on_open = function()
            vim.o.cmdheight = 1
        end,
        on_close = function()
            vim.o.cmdheight = 0
        end,
    }
}
