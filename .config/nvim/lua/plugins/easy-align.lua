return {
    "junegunn/vim-easy-align",
    -- Claude: with cmd = { "EasyAlign" }, `EasyAlign/\\$/` behaves like `EasyAlign/\$/` due to `\\` being
    -- changed to `\` by lazy.nvim's `event.fargs` on the first invocation (where lazy.nvim creates
    -- a placeholder command).
    --
    -- Disabling lazy loading does solve the problem. Claude's claim was not verified,
    -- but the reasoning trace and tool calls were reasonable.
    lazy = false,
    keys = {
        { "gi", "<Plug>(EasyAlign)", mode = { "x", "n" }, noremap = false },
    },
}
