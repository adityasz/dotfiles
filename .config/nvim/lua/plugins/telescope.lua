return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require("telescope").setup({
            defaults = {
                sorting_strategy = "ascending",
                layout_strategy = "vertical",
                layout_config = {
                    vertical = {
                        prompt_position = "top",
                        mirror = true,
                        width = function()
                            return math.min(math.floor(0.8 * vim.o.columns), 90)
                        end,
                    }
                }
            },
        })
    end,
}
