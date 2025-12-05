return {
    {
        'mikesmithgh/kitty-scrollback.nvim',
        enabled = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
        event = { 'User KittyScrollbackLaunch' },
        config = function()
            local config = {
                status_window = {
                    enabled      = false,
                    style_simple = false,
                    autoclose    = false,
                    show_timer   = false,
                    icons = {
                        kitty = ' ',
                        heart = ' ',
                        nvim  = ' '
                    },
                },
                callbacks = {
                    after_ready = function()
                        vim.opt.wrap = true
                    end,
                }
            }
            require('kitty-scrollback').setup({
                myconfig                            = config,
                ksb_builtin_last_cmd_output         = config,
                ksb_builtin_last_visited_cmd_output = config,
                ksb_builtin_get_text_all            = config,
            })
        end
    },
    {
        -- TODO: Switch to https://github.com/mrjones2014/smart-splits.nvim?tab=readme-ov-file#kitty
        --
        -- It also makes resize more intuitive and works in tmux (which is the only way to
        -- multiplex the linux console as far as I understand).
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
