vim.opt.number = true
vim.opt.cmdheight = 1 -- 0
vim.opt.relativenumber = true
vim.opt.updatetime = 100
-- vim.opt.statuscolumn = '%s  %=%{&rnu?v:relnum:v:lnum}   %C'

vim.opt.ai = true
vim.opt.spell = false
vim.opt.linebreak = true
vim.opt.formatoptions:append('cro')
vim.opt.shortmess:remove('S')
vim.opt.fillchars:append('diff: ')

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.textwidth = 0

vim.opt.mouse = ""

vim.opt.background = "light"
vim.cmd("colorscheme light")

vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_cursor_animation_length = 0
