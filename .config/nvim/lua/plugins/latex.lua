return {
    'lervag/vimtex',
    ft = { "tex", "plaintex", "latex" },
    init = function()
        vim.g.vimtex_compiler_latexmk = {
            aux_dir = '.aux',
            options = {
	            '-shell-escape',
	            '-pdf',
	            '-verbose',
	            '-file-line-error',
	            '-synctex=1',
	            '-interaction=nonstopmode'
            },
        }
        vim.g.vimtex_view_method = 'sioyek'
        vim.g.tex_flavor = 'latex'
        vim.g.tex_fast = ''
        vim.g.vimtex_matchparen_enabled = 0
        vim.g.vimtex_quickfix_open_on_warning = 0
    end
}
