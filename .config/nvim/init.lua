vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.clipboard = "osc52"

require("config.lazy")
require("config.options")
require("config.keymap")
require("config.autocmds")
require("config.lsp")
