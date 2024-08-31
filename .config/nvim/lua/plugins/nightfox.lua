return {
    "EdenEast/nightfox.nvim",
    config = function()
        require("nightfox").setup({
            palettes = {
                carbonfox = {
                    bg0 = "#323232";
                    bg1 = "#1e1e1e";
                }
            }
        })
    end
}
