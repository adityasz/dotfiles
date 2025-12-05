-- No plugin exists that can show LSP symbols the way they are supposed to be
-- shown. Apparently, people who do real work do not write neovim plugins.
-- This may be useful when stuff hits the fan and I need to use neovim for what
-- it is not designed for.
return {
    'stevearc/aerial.nvim',
    cmd = { "AerialToggle", "AerialOpen", "AerialClose", "AerialNavToggle" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
        layout = {
            max_width = { 50, 0.8 },
            min_width = { 50, 0 },
            default_direction = "prefer_left",
        },
    },
}
