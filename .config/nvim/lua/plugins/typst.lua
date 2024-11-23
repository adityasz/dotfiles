return {
    'kaarmu/typst.vim',
    config = function()
        vim.g.typst_embedded_languages = {'c', 'cpp', 'python', 'mojo'}
    end
}
