local utils = require("config.utils")
local lspconfig = require("lspconfig")

local server_binaries = {
    bashls = "bash-language-server",
    clangd = "clangd",
    pyright = "pyright-langserver",
    texlab = "texlab",
    racket_langserver = "racket-langserver",
    mojo = "mojo-lsp-server",
    rust_analyzer = "rust-analyzer"
}

for server, binary in pairs(server_binaries) do
    if vim.fn.executable(binary) == 1 then
        lspconfig[server].setup{}
    end
end

if vim.fn.executable("tinymist") == 1 then
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
end
