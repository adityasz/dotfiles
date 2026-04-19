return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            local autopairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")

            autopairs.setup({
                disable_filetype = { "" },
            })

            autopairs.add_rules({
                Rule("$", "$", { "tex", "latex", "typst" })
                    :with_move(function(opts) return opts.next_char == "$" end)
                    :with_cr(function(_) return true end),
                Rule("\\(", "\\)", { "tex", "latex" })
                    :with_move(function(opts) return opts.next_char == ")" end)
                    :with_cr(function(_) return true end),
                Rule("\\[", "\\]", { "tex", "latex" })
                    :with_move(function(opts) return opts.next_char == "]" end)
                    :with_cr(function(_) return true end),
            })

            for _, pair in ipairs({
                { "(",        ")" },
                { "[",        "]" },
                { "{",        "}" },
                { "|",        "|" },
                { "\\|",      "\\|" },
                { "\\{",      "\\}" },
                { "\\lceil",  "\\rceil" },
                { "\\langle", "\\rangle" },
                { "\\lfloor", "\\rfloor" },
            }) do
                autopairs.add_rules({
                    Rule("\\left" .. pair[1], "\\right" .. pair[2], { "tex", "latex" })
                        :with_move(function(opts) return opts.next_char == pair[2]:sub(-1) end)
                        :with_cr(function(_) return true end),
                })
            end
        end
    },
}
