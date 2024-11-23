local opts = {noremap = true, silent = true}
local map = vim.keymap.set

map({'n', 'v', 'i', 'o'}, '<F1>', '<Esc>', opts)
map('n', '<F2>', ':set relativenumber!<CR>', opts)
map('n', '<F3>', ':noh<CR>', opts)

map({'n', 'v'}, 'j', 'gj', opts)
map({'n', 'v'}, 'k', 'gk', opts)
map({'n', 'v'}, '$', 'g$', opts)
map({'n', 'v'}, '0', 'g0', opts)
map({'n', 'v'}, 'gj', 'j', opts)
map({'n', 'v'}, 'gk', 'k', opts)
map({'n', 'v'}, 'g$', '$', opts)
map({'n', 'v'}, 'g0', '0', opts)

map('v', '<C-c>', '"+y', opts)

map('n', '<leader>r', ':IncRename ', opts)
map('n', '<leader>e', ':lua vim.diagnostic.open_float()<CR>', opts)
map('n', '[e', ':lua vim.diagnostic.goto_prev()<CR>', opts)
map('n', ']e', ':lua vim.diagnostic.goto_next()<CR>', opts)

map('n', '<leader>t', function()
        local buffers = vim.tbl_filter(function(buf)
            return vim.api.nvim_buf_is_valid(buf)
        end, vim.api.nvim_list_bufs())
        
        require("telescope.builtin").buffers({
            previewer = false,
            sort_lastused = true,
            layout_config = {
                height = math.min(#buffers, 20) + 10,
                width = 60
            }
        })
    end, opts)

map('n', '<leader>s', function()
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")
    
    builtin.lsp_document_symbols(themes.get_dropdown({
        ignore_symbols = {"parameter", "variable"},
        previewer = false,
        width = 60,
        symbol_width = 0,
        symbol_type_width = 10,
        show_line = true,
        layout_config = {
            height = 30
        }
    }))
end, opts)

map('n', '<leader>f', function()
        require("telescope.builtin").live_grep({
            layout_config = {
                width = 80
            }
        })
    end, opts)

map('n', '<leader> ', function()
        require("telescope.builtin").find_files({
            layout_config = {
                width = 60,
            }
        })
    end, opts)

map('n', '<leader>w', function()
        require("telescope.builtin").lsp_workspace_symbols({
            ignore_symbols = {"parameter", "variable"},
            previewer = false,
            width = 60,
            symbol_width = 0,
            symbol_type_width = 10,
            show_line = true,
            layout_config = {
                height = 30
            }
        })
    end, opts)

-- Handled by the kitty plugin
-- map('n', '<C-j>', ':wincmd j<CR>', opts)
-- map('n', '<C-k>', ':wincmd k<CR>', opts)
-- map('n', '<C-h>', ':wincmd h<CR>', opts)
-- map('n', '<C-l>', ':wincmd l<CR>', opts)

-- S-F5 is F17
-- C-F5 is F29
-- map({'n', 'v', 'i'}, '<F17>', function() require('config.utils').run_single_file() end, {noremap = true, silent = true})
-- map({'n', 'v', 'i'}, '<F29>', function() require('config.utils').debug_single_file() end, {noremap = true, silent = true})
