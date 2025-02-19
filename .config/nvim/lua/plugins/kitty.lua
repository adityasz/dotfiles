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
                            -- vim.opt_local.modifiable = true
                            -- vim.opt_local.listchars = { eol = '$', space = '_', tab = '> ', trail = '*' }
                            -- vim.cmd('silent! %s/\\s\\+$//e')
                            -- vim.cmd('%s/\\s\\+$//e')
                            -- vim.opt_local.modifiable = false
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
            -- vim.keymap.set('n', '{Left-Mapping}', '<cmd>KittyNavigateLeft<cr>', { silent = true })
            -- vim.keymap.set('n', '{Down-Mapping}', '<cmd>KittyNavigateDown<cr>', { silent = true })
            -- vim.keymap.set('n', '{Up-Mapping}', '<cmd>KittyNavigateUp<cr>', { silent = true })
            -- vim.keymap.set('n', '{Right-Mapping}', '<cmd>KittyNavigateRight<cr>', { silent = true })
        end
    }
}
