local opts = {noremap = true, silent = true}
local map = vim.keymap.set

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

map({'n', 'v', 'i', 'o'}, '<F1>', '<Esc>', opts)
map('n', '<F3>', ':noh<CR>', opts)

map({'n', 'v'}, 'j', 'gj', opts)
map({'n', 'v'}, 'k', 'gk', opts)
map({'n', 'v'}, '$', 'g$', opts)
map({'n', 'v'}, '0', 'g0', opts)
map({'n', 'v'}, 'gj', 'j', opts)
map({'n', 'v'}, 'gk', 'k', opts)
map({'n', 'v'}, 'g$', '$', opts)
map({'n', 'v'}, 'g0', '0', opts)

map('n', '<C-j>', ':wincmd j<CR>', opts)
map('n', '<C-k>', ':wincmd k<CR>', opts)
map('n', '<C-h>', ':wincmd h<CR>', opts)
map('n', '<C-l>', ':wincmd l<CR>', opts)

map('v', '<C-c>', '"+y', opts)

map('n', '<leader>f', ':Telescope live_grep<CR>', opts)
map('n', '<leader>lf', ':Telescope find_files<CR>', opts)
map('n', '<leader>lb', ':Telescope buffers<CR>', opts)
map('n', '<leader>lh', ':Telescope help_tags<CR>', opts)

map('n', '<leader>r', ':IncRename ', opts)

-- S-F5 is F17
-- C-F5 is F29
map({'n', 'v', 'i'}, '<F17>', function() require('config.options').run_single_file() end, {noremap = true, silent = true})
map({'n', 'v', 'i'}, '<F29>', function() require('config.options').debug_single_file() end, {noremap = true, silent = true})
