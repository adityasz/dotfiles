return {
    {
        'preservim/vim-markdown',
        ft = { "markdown" },
        init = function()
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_math = 1
            vim.g.vim_markdown_strikethrough = 1
            vim.g.vim_markdown_auto_insert_bullets = 0
            vim.g.vim_markdown_new_list_item_indent = 0
        end
    }
}
