local utils = require("config.utils")
local lspconfig = require("lspconfig")

lspconfig.bashls.setup{}
lspconfig.clangd.setup{}
lspconfig.pyright.setup{}
lspconfig.tinymist.setup{
    cmd = {"tinymist"},
    filetypes = {"typst"},
    single_file_support = true,
    settings = {
        exportPdf = "never",
    },
    on_init = function(client)
        local config = client.config
    end,
    on_new_config = function(new_config, new_root_dir)
        local fname = vim.api.nvim_buf_get_name(0)
        new_config.settings = new_config.settings or {}
        new_config.settings.tinymist = new_config.settings.tinymist or {}
        
        local root = utils.get_project_root(fname)
        new_config.settings.tinymist.rootPath = root
    end,
    root_dir = utils.get_project_root
}
lspconfig.texlab.setup{}
lspconfig.racket_langserver.setup{}
lspconfig.mojo.setup{}
lspconfig.rust_analyzer.setup{}
