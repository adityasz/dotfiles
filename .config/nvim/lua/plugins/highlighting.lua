return {
    {
        'vim-python/python-syntax',
        init = function()
            vim.g.python_highlight_all = 1
        end
    },
    'vim-scripts/TagHighlight',
    {
        'octol/vim-cpp-enhanced-highlight',
        init = function()
            vim.g.cpp_class_scope_highlight = 1
            vim.g.cpp_member_variable_highlight = 1
            vim.g.cpp_class_decl_highlight = 1
            vim.g.cpp_posix_standard = 1
        end
    },
}
