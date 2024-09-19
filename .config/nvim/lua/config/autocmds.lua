local opts = require('config.options')

vim.api.nvim_create_autocmd("FocusGained", {
    pattern = "*",
    callback = function()
        opts.set_color_scheme()
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
        vim.opt.tw = 99
        vim.opt.spell = false
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.linebreak = false
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = {"*.py", "*.lua"},
    callback = function()
        vim.opt.tw = 99
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
        vim.opt.spell = true
        vim.opt.tw = 80
        -- Until TeX has a good formatter, use spaces for indentation.
        vim.opt.expandtab = true
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.md",
    callback = function()
        vim.opt.tw = 80
        vim.opt.spell = true
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true
        vim.opt.linebreak = true
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.rkt",
    callback = function()
        vim.opt.tw = 80
        vim.opt.tabstop = 2
        vim.opt.softtabstop=  2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
        vim.keymap.set({'n', 'v', 'i'}, '<F5>', function() opts.run_racket_file() end, {noremap = true, silent = true})
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.rst",
    callback = function()
        vim.opt.tw = 80
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

vim.api.nvim_create_autocmd({"BufEnter"}, {
    pattern = "*.txt",
    callback = function()
        vim.opt.spell = true
    end
})

vim.api.nvim_create_autocmd({"BufEnter"}, {
    pattern = "*.typ",
    callback = function()
        vim.opt.spell = true
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.textwidth = 80
        vim.opt.expandtab = false
    end
})

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead",}, {
    pattern = "*.typ",
    callback = function()
        vim.opt.spell = true
        vim.keymap.set('n', '<leader>ll', ':TypstWatch<CR>', {noremap = true, silent = true})
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_option(buf, "filetype", "typst")
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.py",
    callback = function()
        vim.keymap.set({'n', 'v', 'i'}, '<F5>', function() opts.run_python_script() end, {noremap = true, silent = true})
    end
})

-- S-F5 is F17
-- C-F5 is F29

-- vim.api.nvim_create_autocmd("BufEnter", {
--     pattern = {"*.c"},
--     callback = function()
--         vim.keymap.set({'n', 'v', 'i'}, '<F17>', function() opts.compile_and_run_c() end, {noremap = true, silent = true})
--         vim.keymap.set({'n', 'v', 'i'}, '<F29>', function() opts.compile_and_debug_c() end, {noremap = true, silent = true})
--     end
-- })
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--     pattern = {"*.c{pp,xx,++,u}"},
--     callback = function()
--         vim.keymap.set({'n', 'v', 'i'}, '<F17>', function() opts.compile_and_run_cpp() end, {noremap = true, silent = true})
--         vim.keymap.set({'n', 'v', 'i'}, '<F29>', function() opts.compile_and_debug_cpp() end, {noremap = true, silent = true})
--     end
-- })
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--     pattern = "*.py",
--     callback = function()
--         vim.keymap.set({'n', 'v', 'i'}, '<F17>', function() opts.run_python_script() end, {noremap = true, silent = true})
--     end
-- })
