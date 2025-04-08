return{
    "akinsho/toggleterm.nvim",
    lazy = false,
    config = function()
        local tgl = require("toggleterm")

        tgl.setup({
            size = 20,
            open_mapping = [[<C-\>]],
            shade_terminals = true,
            shading_factor = 5,
            start_in_insert = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
        })
    end,
}
