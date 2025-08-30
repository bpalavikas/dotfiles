return{
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "typescript", "python", "html" },
                sync_install = false,
                highlight = { enable = true},
                indent = { enable = true },
        }
        end,
    }
}
