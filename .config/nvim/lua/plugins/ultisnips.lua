return {
    'SirVer/ultisnips',
    lazy = false,
    init = function()
        vim.g.UltiSnipsExpandTrigger = '<Tab>'
        vim.g.UltiSnipsJumpForwardTrigger = '<Tab>'
        vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'
    end
}
