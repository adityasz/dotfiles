require("config.lazy")
require("config.options")
require("config.keymap")
require("config.autocmds")

local lspconfig = require("lspconfig")

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
lspconfig.racket_langserver.setup{}
