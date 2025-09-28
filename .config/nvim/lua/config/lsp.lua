local utils = require("config.utils")

vim.lsp.config("tinymist", {
    cmd = {"tinymist"},
    filetypes = {"typst"},
    single_file_support = true,
    settings = {
        exportPdf = "never",
    },
    on_init = function(client)
        local config = client.config
    end,
    -- on_new_config = function(new_config, new_root_dir)
    --     local fname = vim.api.nvim_buf_get_name(0)
    --     new_config.settings = new_config.settings or {}
    --     new_config.settings.tinymist = new_config.settings.tinymist or {}
    --     local root = utils.get_project_root(fname)
    --     new_config.settings.tinymist.rootPath = root
    -- end,
    -- root_dir = utils.get_project_root
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {}
    },
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc')) then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end
})

vim.lsp.config("basedpyright", {
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "standard",
                reportConstantRedefinition = true,
                reportDeprecated = true,
                reportDuplicateImport = true,
                reportIgnoreCommentWithoutRule = true,
                reportMatchNotExhaustive = true,
                reportUnnecessaryCast = true,
                reportUnnecessaryComparison = true,
                reportUnnecessaryContains = true,
                reportUnnecessaryIsInstance = true,
            }
        }
    }
})

local server_binaries = {
    bashls = "bash-language-server",
    clangd = "clangd",
    basedpyright = "basedpyright-langserver",
    -- ty = "ty",
    ruff = "ruff",
    texlab = "texlab",
    racket_langserver = "racket-langserver",
    mojo = "mojo-lsp-server",
    rust_analyzer = "rust-analyzer",
    lua_ls = "lua-language-server",
    tinymist = "tinymist",
}

for server, binary in pairs(server_binaries) do
    if vim.fn.executable(binary) == 1 then
        vim.lsp.enable(server)
    end
end
