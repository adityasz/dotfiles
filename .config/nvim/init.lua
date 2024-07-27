require("config.options")
require("config.keymap")
require("config.autocmds")
require("config.lazy")

local lspconfig = require('lspconfig')

lspconfig.clangd.setup{}
lspconfig.pyright.setup{}
lspconfig.tinymist.setup{
    cmd = {"tinymist"},
    filetypes = {"typst"},
    single_file_support = true,
    settings = {
        exportPdf = "never"
    }
}
lspconfig.texlab.setup{}
