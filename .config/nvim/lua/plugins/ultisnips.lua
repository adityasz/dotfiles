return {
    'SirVer/ultisnips',
    ft = { "tex", "plaintex", "latex" },
    init = function()
        vim.g.UltiSnipsExpandTrigger = '<Tab>'
        vim.g.UltiSnipsJumpForwardTrigger = '<Tab>'
        vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'
    end
}
