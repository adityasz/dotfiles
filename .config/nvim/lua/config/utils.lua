local utils = {}

utils.set_color_scheme = function()
    if not os.execute("command -v gsettings > /dev/null 2>&1") then
        vim.opt.background = "light"
        vim.cmd("colorscheme light")
        require("lualine").setup({options = {theme = require("config.themes.lualine.light")}})
        return "light"
    end

    local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme")
    local result = handle:read("*a")
    handle:close()
    local gnome_scheme = result:gsub("^%s*(.-)%s*$", "%1")
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

utils.cursor_position = function()
    return tostring(vim.fn['line']("."))..":"..tostring(vim.fn['virtcol']("."))
end

-- credits: jdhao/nvim-config
function utils.may_create_dir(dir)
    if vim.bo.filetype == "oil" then
        is_oil_buffer = true
    end

    local res = vim.fn.isdirectory(dir)

    if res == 0 then
        vim.fn.mkdir(dir, "p")
    end
end

-- credits: Claude 3.5 Sonnet (new)
function utils.get_project_root(fname)
    -- Get the directory containing the current file
    local file_dir = vim.fn.fnamemodify(fname, ':h')

    -- If we're in a report directory, return its parent DIRECTORY, not the path
    if vim.fn.fnamemodify(file_dir, ':t') == 'report' then
        return vim.fn.fnamemodify(file_dir, ':h')
    end

    -- Otherwise look for common project markers
    local markers = {
        ".git",
        "Makefile",
        "CMakeLists.txt",
        "pixi.toml",
        "pyproject.toml",
        "Cargo.toml"
    }

    local util = require('lspconfig.util')
    local root = util.root_pattern(unpack(markers))(fname)
    if root then
        return root
    end

    -- If no other root found, use the current directory
    return file_dir
end

utils.get_symbol_count = function(scope)
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

-- TODO: combine into one function:

utils.run_python_script = function()
    local filename = vim.fn.expand("%:p")
    local command = string.format("!python %s", filename)
    vim.cmd("write")
    vim.cmd(command)
end

utils.run_racket_file = function()
    local filename = vim.fn.expand("%:p")
    local command = string.format("!racket %s", filename)
    vim.cmd("write")
    vim.cmd(command)
end

return utils
