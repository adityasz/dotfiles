local utils = {}

-- credits: https://github.com/ronisbr
-- https://github.com/nvim-lualine/lualine.nvim/issues/147#issuecomment-808905433
function utils.cursor_position()
    return tostring(vim.fn['line']("."))..":"..tostring(vim.fn['virtcol']("."))
end

-- credits: https://github.com/jdhao/nvim-config
function utils.may_create_dir(dir)
    if vim.bo.filetype == "oil" then
        return
    end

    local res = vim.fn.isdirectory(dir)

    if res == 0 then
        vim.fn.mkdir(dir, "p")
    end
end

return utils
