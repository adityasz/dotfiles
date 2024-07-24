return {
    -- 'tpope/vim-commentary',
    -- config = function()
    --     vim.api.nvim_create_autocmd("BufEnter", {
    --         pattern = {"*.{c,pp,xx,++,u}", "*.{h, hh,xx}", "*.asm", "Makefile"},
    --         callback = function()
    --             vim.opt_local.commentstring = '//\ %s'
    --         end
    --     })
    -- end
    'numToStr/Comment.nvim',
    opts = {
        -- options go here
    }
}
