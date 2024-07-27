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

    if gnome_scheme == "'prefer-dark'" and vim.g.colors_name ~= "dark" then
        vim.opt.background = "dark"
        vim.cmd("colorscheme dark")
    elseif gnome_scheme == "'prefer-light'" and vim.g.colors_name ~= "light" then
        vim.opt.background = "light"
        vim.cmd("colorscheme light")
    end
end

M.compile_and_run_c = function()
    local file = vim.fn.expand('%:p')
    local name = vim.fn.expand('%:t:r')
    local cmd = string.format('tmux new-window -n "%s" "gcc -O3 -march=native -mtune=native %s -o %s && ./%s; read"', name, file, name, name)
    vim.cmd("write")
    vim.fn.system(cmd)
    vim.fn.system('tmux select-window -t "' .. name .. '"')
end

M.compile_and_run_cpp = function()
    local file = vim.fn.expand('%:p')
    local name = vim.fn.expand('%:t:r')
    local cmd = string.format('tmux new-window -n "%s" "g++ -std=c++23 -O3 -march=native -mtune=native -lfmt %s -o %s && ./%s; read"', name, file, name, name)
    vim.cmd("write")
    vim.fn.system(cmd)
    vim.fn.system('tmux select-window -t "' .. name .. '"')
end

M.compile_and_debug_c = function()
    local file = vim.fn.expand('%:p')
    local name = vim.fn.expand('%:t:r')
    local cmd = string.format('tmux new-window -n "%s" "gcc -ggdb3 %s -o %s; gdb -tui %s"', name, file, name, name)
    vim.cmd("write")
    vim.fn.system(cmd)
    vim.fn.system('tmux select-window -t "' .. name .. '"')
end

M.compile_and_debug_cpp = function()
    local file = vim.fn.expand('%:p')
    local name = vim.fn.expand('%:t:r')
    local cmd = string.format('tmux new-window -n "%s" "g++ -std=c++23 -ggdb3 -lfmt %s -o %s; gdb -tui %s"', name, file, name, name)
    vim.cmd("write")
    vim.fn.system(cmd)
    vim.fn.system('tmux select-window -t "' .. name .. '"')
end

M.run_python_script = function()
    local file = vim.fn.expand('%:p')
    local name = vim.fn.expand('%:t:r')
    local cmd = string.format('tmux new-window -n "%s" "python %s; read"', name, file)
    vim.cmd("write")
    vim.fn.system(cmd)
    vim.fn.system('tmux select-window -t "' .. name .. '"')
end

M.cursor_position = function()
    return tostring(vim.fn['line']("."))..":"..tostring(vim.fn['virtcol']("."))
end

M.set_color_scheme()

return M
