local utils = require("config.utils")

-- credits: Kovid Goyal
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume", "UIEnter" }, {
    group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
    callback = function()
        if vim.api.nvim_ui_send then
            vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
        else
            io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
        end
    end,
})

-- credits: Kovid Goyal
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
    group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
    callback = function()
        if vim.api.nvim_ui_send then
            vim.api.nvim_ui_send("\x1b]1337;SetUserVar=in_editor=MQo\007")
        else
            io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
        end
    end,
})

-- credits: jdhao/nvim-config
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("auto_create_dir", {clear = true}),
    callback = function(ctx)
        local dir = vim.fn.fnamemodify(ctx.file, ":p:h")
        utils.may_create_dir(dir)
    end,
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.ixx",
    callback = function()
        vim.bo.filetype = "cpp"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"lex", "c", "asm", "make"},
    callback = function()
        vim.opt.tabstop = 8
        vim.opt.shiftwidth = 8
        vim.opt.textwidth = 80
        vim.opt.expandtab = false
        vim.opt.linebreak = false
        vim.opt.spell = false
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "yacc",
    callback = function()
        vim.opt.commentstring = "// %s"
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "sh",
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.textwidth = 80
        vim.opt.expandtab = false
        vim.opt.linebreak = false
        vim.opt.spell = false
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"cpp", "cuda"},
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.textwidth = 99
        vim.opt.expandtab = false
        vim.opt.linebreak = false
        vim.opt.spell = false
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"html", "css", "xml", "json", "javascript"},
    callback = function()
        vim.opt.textwidth = 99
        vim.opt.expandtab = false
        vim.opt.linebreak = false
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"python", "lua"},
    callback = function()
        vim.opt.textwidth = 99
        vim.opt.linebreak = false
        vim.opt.spell = false
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.textwidth = 80
        vim.opt.expandtab = true -- Until TeX has a good formatter (which will never happen), use spaces for indentation
        vim.opt.spell = true
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt.textwidth = 80
        vim.opt.linebreak = true
        vim.opt.spell = true
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"scheme", "racket", "haskell"},
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.textwidth = 80
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "rst",
    callback = function()
        vim.opt.tabstop = 8
        vim.opt.shiftwidth = 8
        vim.opt.textwidth = 80
        vim.opt.expandtab = false
        vim.opt.linebreak = true
        vim.opt.spell = true
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "txt",
    callback = function()
        vim.opt.spell = true
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "typst",
    callback = function()
        vim.opt.textwidth = 80
        vim.opt.spell = true
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "man",
    callback = function()
        -- vim.keymap.set({'n', 'v', 'i'}, '<leader>s', ':AerialOpen<CR>', {noremap = true, silent = true})
        vim.keymap.set({'n', 'v', 'i'}, '<leader>s', ':Telescope aerial<CR>', {noremap = true, silent = true})
    end
})
