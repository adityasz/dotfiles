vim.opt.number = true
vim.opt.cmdheight = 0
vim.opt.relativenumber = true
vim.opt.updatetime = 100

vim.opt.ai = true
vim.opt.spell = true
vim.opt.linebreak = true
vim.opt.formatoptions:append('cro')
vim.opt.shortmess:remove('S')

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.textwidth = 0

require("config.utils").set_color_scheme()
