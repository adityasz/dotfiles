vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.{c,pp,xx,++,u}", "*.{h, hh,xx}", "*.asm", "Makefile"},
    callback = function()
        vim.opt.tw = 80
        vim.opt.spell = false
        vim.opt.linebreak = false
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.html", "*.css", "*.xml", "*.json", "*.yaml", "*.yml", "*.js"},
    callback = function()
        vim.opt.tw = 0
        vim.opt.spell = false
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.linebreak = false
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.py", "*.lua"},
    callback = function()
        vim.opt.tw = 80
        vim.opt.spell = false
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.softtabstop = 4
        vim.opt.expandtab = true
        vim.opt.linebreak = false
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.tex",
    callback = function()
        vim.opt.tw = 80
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    callback = function()
        vim.opt.tw = 72
        vim.opt.spell = true
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true
        vim.opt.linebreak = true
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.rst",
    callback = function()
        vim.opt.tw = 72
        vim.opt.spell = true
        vim.opt.tabstop = 8
        vim.opt.shiftwidth = 8
        vim.opt.expandtab = false
        vim.opt.linebreak = true
    end
})

vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
            fg = '#555555',
            ctermfg = 8,
            force = true
        })
    end
})

vim.api.nvim_create_autocmd("FocusGained", {
    pattern = "*",
    callback = function()
        require("config.options").set_color_scheme()
        require('lualine').setup()
        vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
            fg = '#555555',
            ctermfg = 8,
            force = true
        })
    end
})
