return {
    "smart-splits-nvim/smart-splits.nvim",
    build = './kitty/install-kittens.bash',
    lazy = false,
    opts = { at_edge = "stop" },
    keys = {
        { "<M-h>", function() require("smart-splits").move_cursor_left() end},
        { "<M-j>", function() require("smart-splits").move_cursor_down() end},
        { "<M-k>", function() require("smart-splits").move_cursor_up() end},
        { "<M-l>", function() require("smart-splits").move_cursor_right() end},
    },
}
