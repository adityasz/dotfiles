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
        require("lualine").setup({options = {theme = require("config.themes.lualine.dark")}})
        return "dark"
    elseif (gnome_scheme == "'prefer-light'" or gnome_scheme == "'default'") and vim.g.colors_name ~= "light" then
        vim.opt.background = "light"
        vim.cmd("colorscheme light")
        require("lualine").setup({options = {theme = require("config.themes.lualine.light")}})
        return "light"
    end

    return "light"
end

M.cursor_position = function()
    return tostring(vim.fn['line']("."))..":"..tostring(vim.fn['virtcol']("."))
end

-- credits: jdhao/nvim-config
function M.may_create_dir(dir)
    local res = vim.fn.isdirectory(dir)

    if res == 0 then
        vim.fn.mkdir(dir, "p")
    end
end

-- credits: Claude 3.5 Sonnet (new)
function M.get_project_root(fname)
    -- Get the directory containing the current file
    local file_dir = vim.fn.fnamemodify(fname, ':h')
    
    -- If we're in a report directory, return its parent DIRECTORY, not the path
    if vim.fn.fnamemodify(file_dir, ':t') == 'report' then
        return vim.fn.fnamemodify(file_dir, ':h')
    end
    
    -- Otherwise look for common project markers
    local markers = {
        '.git',
        'Makefile',
        'CMakeLists.txt',
        'pixi.toml',
        'pyproject.toml',
        'mojoproject.toml'
    }
    
    local util = require('lspconfig.util')
    local root = util.root_pattern(unpack(markers))(fname)
    if root then
        return root
    end
    
    -- If no other root found, use the current directory
    return file_dir
end

M.get_symbol_count = function(scope)
    local symbols = vim.lsp.buf_request_sync(0, 'textDocument/documentSymbols', {
        textDocument = vim.lsp.util.make_text_document_params()
    }, 1000)
    
    if not symbols then return 0 end
    
    local count = 0
    for _, response in pairs(symbols) do
        if response.result then
            count = count + #response.result
        end
    end
    return count
end

-- M.get_symbol_count = function(scope)
--     local symbols = vim.lsp.buf_request_sync(0, 'textDocument/documentSymbols', {
--         textDocument = vim.lsp.util.make_text_document_params()
--     }, 1000)
--     
--     if not symbols then return 0 end
--     
--     local count = 0
--     for _, response in pairs(symbols) do
--         if response.result then
--             count = count + #response.result
--         end
--     end
--     return count
-- end

-- TODO: combine into one function:

M.run_python_script = function()
    local filename = vim.fn.expand("%:p")
    local command = string.format("!python %s", filename)
    vim.cmd("write")
    vim.cmd(command)
end

M.run_racket_file = function()
    local filename = vim.fn.expand("%:p")
    local command = string.format("!racket %s", filename)
    vim.cmd("write")
    vim.cmd(command)
end

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
