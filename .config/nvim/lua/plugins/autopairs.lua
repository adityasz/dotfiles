return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {
        ignored_next_char = "[%w%.]",
        enable_check_bracket_line = false
    },
    config = function()
        require('nvim-autopairs').setup({
            disable_filetype = {"", "tex", "racket"},
        })
    end
}
