return {
    {
        'mikesmithgh/kitty-scrollback.nvim',
        enabled = true,
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
        event = { 'User KittyScrollbackLaunch' },
        -- version = '*', -- latest stable version, may have breaking changes if major version changed
        -- version = '^5.0.0', -- pin major version, include fixes and features that do not have breaking changes
        config = function()
            require('kitty-scrollback').setup({
                myconfig = {
                    status_window = {
                        enabled = false,
                        style_simple = false,
                        autoclose = false,
                        show_timer = false,
                        icons = {
                            kitty = ' ',
                            heart = ' ',
                            nvim = ' '
                        },
                    },
                    callbacks = {
                        after_ready = function()
                            vim.opt.wrap = true
                        end,
                    },
                }
            })
        end
    },
    {
        'knubie/vim-kitty-navigator',
        config = function()
            vim.g.kitty_navigator_no_mappings = 1
            vim.keymap.set('n', '<M-h>', '<cmd>KittyNavigateLeft<cr>',  { silent = true })
            vim.keymap.set('n', '<M-j>', '<cmd>KittyNavigateDown<cr>',  { silent = true })
            vim.keymap.set('n', '<M-k>', '<cmd>KittyNavigateUp<cr>',    { silent = true })
            vim.keymap.set('n', '<M-l>', '<cmd>KittyNavigateRight<cr>', { silent = true })
        end
    }
}
