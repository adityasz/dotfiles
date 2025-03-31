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
map('n', '<M-e>', ':Neotree toggle<CR> ', opts)
map('n', '<leader>r', ':IncRename ', opts)
map('n', '<leader>e', ':lua vim.diagnostic.open_float()<CR>', opts)
map('n', '<leader>z', ':ZenMode<CR>', opts)
map('n', '[e', ':lua vim.diagnostic.goto_prev()<CR>', opts)
map('n', ']e', ':lua vim.diagnostic.goto_next()<CR>', opts)

-- Telescope buffers
map('n', '<leader>t', function()
        local buffers = vim.tbl_filter(function(buf)
            return vim.api.nvim_buf_is_valid(buf)
        end, vim.api.nvim_list_bufs())
        require("telescope.builtin").buffers({
            layout_config = {
                height = math.max(#buffers, 1) + 5,
                width = function()
                    return math.min(math.floor(0.8 * vim.o.columns), 40)
                end,
            }})
    end, opts)

-- Telescope find_files
map('n', '<leader> ', function()
    local function count_files_recursively(start_path)
        start_path = start_path or vim.fn.getcwd()
        local cmd = string.format("fd -t f -H -E '.*' . '%s' | wc -l", start_path)
        local file_count = tonumber(vim.fn.trim(vim.fn.system(cmd)))
        return file_count or 0
    end
    local files = count_files_recursively()
    require("telescope.builtin").find_files({
        preview = true,
        layout_config = {
            height = math.max(files, 1) + 5,
            width = function()
                return math.min(math.floor(0.8 * vim.o.columns), 40)
            end,
        },
        hidden = false,  -- Explicitly set to not show hidden files
        no_ignore = false,  -- Respect .gitignore and other ignore files
        file_ignore_patterns = {"^%."}  -- Ignore files starting with a dot
    })
    end, opts)

map('n', '<leader>s', ":Telescope lsp_document_symbols<CR>", opts)
map('n', '<leader>f', ":Telescope live_grep<CR>", opts)
map('n', '<leader>w', ":Telescope lsp_workspace_symbols<CR>", opts)

map('n', '<M-a>', ":CodeCompanionChat<CR>", opts)

-- Handled by the kitty plugin
-- map('n', '<C-j>', ':wincmd j<CR>', opts)
-- map('n', '<C-k>', ':wincmd k<CR>', opts)
-- map('n', '<C-h>', ':wincmd h<CR>', opts)
-- map('n', '<C-l>', ':wincmd l<CR>', opts)

-- S-F5 is F17
-- C-F5 is F29
-- map({'n', 'v', 'i'}, '<F17>', function() require('config.utils').run_single_file() end, {noremap = true, silent = true})
-- map({'n', 'v', 'i'}, '<F29>', function() require('config.utils').debug_single_file() end, {noremap = true, silent = true})
