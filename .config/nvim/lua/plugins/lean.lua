return {
    "Julian/lean.nvim",
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },

    dependencies = {
        -- optional dependencies:

        -- 'nvim-telescope/telescope.nvim', -- for Lean-specific pickers
        -- 'andymass/vim-matchup',          -- for enhanced % motion behavior
        -- 'andrewradev/switch.vim',        -- for switch support
    },

    init = function() vim.g.lean_config = { mappings = true } end
}
