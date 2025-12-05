return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        -- The following function is adapted from
        -- https://www.reddit.com/r/neovim/comments/10asvod/comment/j472wib/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
        local layouts = require("telescope.pickers.layout_strategies")
        layouts.vertical_merged = function(picker, max_columns, max_lines, layout_config)
            local layout = layouts.vertical(picker, max_columns, max_lines, layout_config)
            layout.prompt.borderchars  = { '─','│','─','│','┌','┐','┘','└' }
            layout.results.borderchars = { '─','│','─','│','├','┤','┘','└' }
            layout.results.line = layout.results.line - 1
            if picker.previewer and layout.preview then
                layout.results.borderchars = { '─','│','─','│','├','┤','┤','├' }
                layout.preview.borderchars = { '─','│','─','│','├','┤','┘','└' }
                layout.preview.line = layout.preview.line - 2
            end
            return layout
        end

        require("telescope").setup({
            defaults = {
                results_title = "",
                prompt_prefix = "  ",
                selection_caret = "  ",
                sorting_strategy = "ascending",
                layout_strategy = "vertical_merged",
                previewer = false,
                layout_config = {
                    vertical = {
                        prompt_position = "top",
                        mirror = true,
                        width = function()
                            return math.min(math.floor(0.8 * vim.o.columns), 80)
                        end,
                    }
                }
            },
            pickers = {
                buffers = {
                    prompt_title = "",
                    previewer = false,
                    sort_lastused = true,
                },
                find_files = {
                    prompt_title = "",
                    previewer = false,
                    layout_config = {
                        width = function()
                            return math.min(math.floor(0.8 * vim.o.columns), 40)
                        end,
                    }
                },
                live_grep = {
                    prompt_title = "",
                    ignore_symbols = {"parameter", "variable"},
                    previewer = true,
                    preview_title = "",
                    symbol_width = 0,
                    symbol_type_width = 10,
                    show_line = true,
                    layout_config = {height = 30}
                },
                -- the lsp related pickers are terrible, so no config for them
            },
        })
    end
}
