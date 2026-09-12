return {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    cmd = {
        'KittyScrollbackGenerateKittens',
        'KittyScrollbackCheckHealth',
        'KittyScrollbackGenerateCommandLineEditing',
    },
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
                    -- Credits (or in case the solution is stupid, negative credit): Claude Sonnet 4.5.
                    vim.keymap.set('n', '$', 'g_', { buffer = true })
                    vim.keymap.set('v', '$', 'g_', { buffer = true })
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
}
