local utils = require("config.utils")

vim.api.nvim_create_autocmd("FocusGained", {
    pattern = "*",
    callback = function()
        utils.set_color_scheme()
        require('lualine').setup()

        local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme")
        local result = handle:read("*a")
        handle:close()
        local gnome_scheme = result:gsub("^%s*(.-)%s*$", "%1")
        local fg = ''
        if gnome_scheme == "'prefer-dark'" then
            fg_ = '#555555'
        else
            fg_ = '#bbbbbb'
        end

        vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
            fg = fg_,
            ctermfg = 8,
            force = true
        })
    end
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
        vim.opt.expandtab = true -- Until TeX has a good formatter, use spaces for indentation.
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

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.rkt",
    callback = function()
        vim.keymap.set({'n', 'v', 'i'}, '<F5>', function() utils.run_racket_file() end, {noremap = true, silent = true})
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

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "CopilotSuggestion", {
            fg = "#555555",
            ctermfg = 8,
            force = true
        })
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

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*.typ",
    callback = function()
        vim.opt.spell = true
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.textwidth = 80
        vim.keymap.set('n', '<leader>ll', ':TypstWatch<CR>', {noremap = true, silent = true})
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_option(buf, "filetype", "typst")
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.py",
    callback = function()
        vim.keymap.set({'n', 'v', 'i'}, '<F5>', function() utils.run_python_script() end, {noremap = true, silent = true})
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "man",
    callback = function()
        -- vim.keymap.set({'n', 'v', 'i'}, '<leader>s', ':AerialOpen<CR>', {noremap = true, silent = true})
        vim.keymap.set({'n', 'v', 'i'}, '<leader>s', ':Telescope aerial<CR>', {noremap = true, silent = true})
    end
})
