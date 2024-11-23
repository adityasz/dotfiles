return {
    {
        'neovim/nvim-lspconfig'
    },
    {
        'michaeljsmith/vim-indent-object'
    },
    {
        'NMAC427/guess-indent.nvim'
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
        opts = {
            ignored_next_char = "[%w%.]",
            enable_check_bracket_line = false
        },
        config = function()
            require('nvim-autopairs').setup({
                disable_filetype = {"", "tex", "racket"},
            })
        end
    },
    {
        -- 'tpope/vim-commentary',
        -- config = function()
        --     vim.api.nvim_create_autocmd("BufEnter", {
        --         pattern = {"*.{c,pp,xx,++,u}", "*.{h, hh,xx}", "*.asm", "Makefile"},
        --         callback = function()
        --             vim.opt_local.commentstring = '//\ %s'
        --         end
        --     })
        -- end
        'numToStr/Comment.nvim',
        opts = {
            -- options go here
        }
    },
    {
        -- Use treesitter to auto close and auto rename html tag
        "windwp/nvim-ts-autotag"
    },
    {
        'vim-python/python-syntax',
        init = function()
            vim.g.python_highlight_all = 1
        end
    },
    {
        'vim-scripts/TagHighlight',
    },
    {
        'octol/vim-cpp-enhanced-highlight',
        init = function()
            vim.g.cpp_class_scope_highlight = 1
            vim.g.cpp_member_variable_highlight = 1
            vim.g.cpp_class_decl_highlight = 1
            vim.g.cpp_posix_standard = 1
        end
    },
    {
        'smjonas/inc-rename.nvim',
        config = function()
            require("inc_rename").setup()
        end
    }
}
