return {
    'SirVer/ultisnips',
    ft = { "tex", "plaintex", "latex", "typst", "snippets" },
    init = function()
        vim.g.UltiSnipsExpandTrigger = '<Tab>'
        vim.g.UltiSnipsJumpForwardTrigger = '<Tab>'
        vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'
    end
}
