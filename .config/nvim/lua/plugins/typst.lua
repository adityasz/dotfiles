return {
    'kaarmu/typst.vim',
    ft = { "typst" },
    init = function()
        vim.g.typst_embedded_languages = {'c', 'cpp', 'python', 'mojo'}
    end
}
