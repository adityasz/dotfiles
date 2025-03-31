-- Quick and ugly fix to disable Telescope previewer:
--
-- In $XDG_DATA_HOME/nvim/lazy/aerial.nvim/lua/telescope/_extensions/aerial.lua, make the
-- following change:
--
-- -- Reverse the symbols so they have the same top-to-bottom order as in the file
-- local sorting_strategy = opts.sorting_strategy or conf.sorting_strategy
-- if sorting_strategy == "descending" then
--   util.tbl_reverse(results)
--   default_selection_index = #results - (default_selection_index - 1)
-- end
-- pickers
--   .new(opts, {
--     prompt_title = "Document Symbols",
--     finder = finders.new_table({
--       results = results,
--       entry_maker = make_entry,
--     }),
--     default_selection_index = default_selection_index,
--     sorter = conf.generic_sorter(opts),
--     -- previewer = conf.qflist_previewer(opts),
--     previewer = false, -- THIS CHANGE
--     push_cursor_on_edit = true,
--   })
--   :find()

return {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require("aerial").setup({
            layout = {
                max_width = {50, 0.8},
                min_width = {50, 0},
                default_direction = "prefer_left",
            }
        })
    end
}
