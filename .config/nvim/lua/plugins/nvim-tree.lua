return{
    "nvim-tree/nvim-tree.lua",
    enabled = false,
    lazy = false,
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        local nvimtree = require("nvim-tree")

        --vim.g.loaded_netrw = 1
        --vim.g.loaded_netrwPlugin = 1

        -- config
        nvimtree.setup({
            view = {
                width = 35,
                relativenumber = true,
            },
            -- change arrow icons
            renderer = {
                indent_markers = {
                    enable = true,
                },
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                        },
                    },
                },
            }, 
            filters = {
                dotfiles = true,
            },
            git = {
                ignore = false,
            },
        })
    end,
}

