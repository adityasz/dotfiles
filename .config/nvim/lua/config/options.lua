vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 100

vim.opt.ai = true
vim.opt.spell = true
vim.opt.linebreak = true
vim.opt.formatoptions:append('cro')
vim.opt.shortmess:remove('S')

vim.opt.tw = 0
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.expandtab = false

local M = {}

M.set_color_scheme = function()
    local function execute_command(cmd)
        local handle = io.popen(cmd)
        local result = handle:read("*a")
        handle:close()
        return result:gsub("^%s*(.-)%s*$", "%1")
    end

    local gnome_scheme = execute_command("gsettings get org.gnome.desktop.interface color-scheme")

    if gnome_scheme == "'prefer-dark'" then
        vim.opt.background = "dark"
        vim.cmd("colorscheme dark")
    else
        vim.opt.background = "light"
        vim.cmd("colorscheme light")
    end
end

M.set_color_scheme()

return M
