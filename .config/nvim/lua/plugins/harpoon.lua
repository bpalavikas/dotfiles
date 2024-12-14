return{
    "ThePrimeagen/harpoon",
    lazy = false,
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        local harp = require("harpoon")
        harp.setup({
        })
    end,
}
