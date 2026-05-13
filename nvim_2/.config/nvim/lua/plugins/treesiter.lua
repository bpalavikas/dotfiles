return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "typescript", "python", "html", "kotlin" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
