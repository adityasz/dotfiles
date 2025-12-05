vim.lsp.config("tinymist", {
    cmd = {"tinymist"},
    filetypes = {"typst"},
    single_file_support = true,
    settings = {
        exportPdf = "never",
    },
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

-- TODO[blocker: ty stable]: Replace basedpyright with ty
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.py",
    callback = function()
        -- find the PEP 723 script marker in the first three lines
        -- (this is not what PEP 723 says, but it is usually within the first three lines)
        local lines = vim.api.nvim_buf_get_lines(0, 0, 3, false)
        for _, line in ipairs(lines) do
            if line == "# /// script" then
                -- Set up a one-time autocmd to detect when basedpyright attaches
                vim.api.nvim_create_autocmd("LspAttach", {
                    callback = function(args)
                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                        if client and client.name == "basedpyright" then
                            vim.lsp.stop_client(client.id)
                            local bufpath = vim.api.nvim_buf_get_name(0)
                            if not vim.fn.executable("uv") then
                                return
                            end
                            local python_path = vim.trim(vim.fn.system(string.format("uv python find --script %s", vim.fn.shellescape(bufpath))))
                            client.config.settings.python = client.config.settings.python or {}
                            client.config.settings.python.pythonPath = python_path
                            vim.lsp.start(client.config)
                            return true  -- remove this autocmd after first trigger
                        end
                    end,
                    once = false,  -- handle removal manually to filter by client name
                })
                break
            end
        end
    end,
})
