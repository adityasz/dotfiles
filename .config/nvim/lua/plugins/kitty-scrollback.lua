return {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^5.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
        require('kitty-scrollback').setup({
            status_window = {
                enabled = true,
                style_simple = false,
                autoclose = false,
                show_timer = false,
                icons = {
                    kitty = ' ',
                    heart = ' ',
                    nvim = ' ',
                },
            },
        })
    end,
}
