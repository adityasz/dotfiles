return {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } }, -- optional
    lazy = false, -- Lazy loading is not recommended because plugin author skill/time issue
    config = function()
        require("oil").setup({
            view_options = {
                show_hidden = true
            }
        })
    end
}
