vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 100

vim.opt.ai = true
vim.opt.spell = false
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
    elseif (gnome_scheme == "'prefer-light'" or gnome_scheme == "'default'") and vim.g.colors_name ~= "light" then
        vim.opt.background = "light"
        vim.cmd("colorscheme light")
    end
end

M.run_single_file = function()
    local file = vim.fn.expand("%:p")
    local name = vim.fn.expand('%:t:r')
    local filetype = vim.bo.filetype
    local cmd

    vim.cmd("write")

    -- if filetype == "c" then
    --     cmd = string.format('gcc -Ofast -march=native -mtune=native -Wall %s -o %s && ./%s', file, name, name)
    -- elseif filetype == "cpp" then
    --     cmd = string.format('g++ -std=c++23 -Ofast -march=native -mtune=native -Wall -lfmt %s -o %s && ./%s', file, name, name)
    -- elseif filetype == "python" then
    --     cmd = string.format('python 3 %s', file)
    -- else
    --     print("Not implemented for this filetype")
    -- end
    --
    -- vim.fn.system(string.format('kitty @ launch --type os-window --title "%s" %s; read', name, cmd))
end

M.debug_single_file = function()
    local file = vim.fn.expand("%:p")
    local name = vim.fn.expand('%:t:r')
    local filetype = vim.bo.filetype
    local cmd

    vim.cmd("write")

    -- if filetype == "c" then
    --     cmd = string.format('gcc -Ofast -march=native -mtune=native -Wall %s -o %s && ./%s', file, name, name)
    -- elseif filetype == "cpp" then
    --     cmd = string.format('g++ -std=c++23 -Ofast -march=native -mtune=native -Wall -lfmt %s -o %s && ./%s', file, name, name)
    -- elseif filetype == "python" then
    --     cmd = string.format('python 3 %s', file)
    -- else
    --     print("Not implemented for this filetype")
    -- end
    --
    -- vim.fn.system(string.format('kitty @ launch --type os-window --title "%s" %s; read', name, cmd))
end


M.cursor_position = function()
    return tostring(vim.fn['line']("."))..":"..tostring(vim.fn['virtcol']("."))
end

M.set_color_scheme()

return M

-- I no longer use tmux. I do not need session persistence and
-- Kitty is better in every measurable metric.
--
-- M.compile_and_run_c = function()
--     local file = vim.fn.expand('%:p')
--     local name = vim.fn.expand('%:t:r')
--     local cmd = string.format('tmux new-window -n "%s" "gcc -Ofast -march=native -mtune=native -Wall %s -o %s && ./%s; read"', name, file, name, name)
--     vim.cmd("write")
--     vim.fn.system(cmd)
--     vim.fn.system('tmux select-window -t "' .. name .. '"')
-- end
--
-- M.compile_and_run_cpp = function()
--     local file = vim.fn.expand('%:p')
--     local name = vim.fn.expand('%:t:r')
--     local cmd = string.format('tmux new-window -n "%s" "g++ -std=c++23 -Ofast -march=native -mtune=native -lfmt -Wall %s -o %s && ./%s; read"', name, file, name, name)
--     vim.cmd("write")
--     vim.fn.system(cmd)
--     vim.fn.system('tmux select-window -t "' .. name .. '"')
-- end
--
-- M.compile_and_debug_c = function()
--     local file = vim.fn.expand('%:p')
--     local name = vim.fn.expand('%:t:r')
--     local cmd = string.format('tmux new-window -n "%s" "gcc -ggdb3 -Wall %s -o %s; gdb -tui %s"', name, file, name, name)
--     vim.cmd("write")
--     vim.fn.system(cmd)
--     vim.fn.system('tmux select-window -t "' .. name .. '"')
-- end
--
-- M.compile_and_debug_cpp = function()
--     local file = vim.fn.expand('%:p')
--     local name = vim.fn.expand('%:t:r')
--     local cmd = string.format('tmux new-window -n "%s" "g++ -std=c++23 -ggdb3 -lfmt -Wall %s -o %s; gdb -tui %s"', name, file, name, name)
--     vim.cmd("write")
--     vim.fn.system(cmd)
--     vim.fn.system('tmux select-window -t "' .. name .. '"')
-- end
--
-- M.run_python_script = function()
--     local file = vim.fn.expand('%:p')
--     local name = vim.fn.expand('%:t:r')
--     local cmd = string.format('tmux new-window -n "%s" "python %s; read"', name, file)
--     vim.cmd("write")
--     vim.fn.system(cmd)
--     vim.fn.system('tmux select-window -t "' .. name .. '"')
-- end
