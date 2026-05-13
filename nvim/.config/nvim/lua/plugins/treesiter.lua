return {
  {
    "nvim-treesitter/nvim-treesitter",

    branch = "master",

    build = ":TSUpdate",

    event = { "BufReadPost", "BufNewFile" },

    opts = {
      ensure_installed = {
        "vim",
        "vimdoc",
        "lua",
        "c",
        "cpp",
        "rust",
        "python",
        "go",
        "json",
        "bash",
        "markdown",
        "markdown_inline",
        "cmake",
        "make",
        "yaml",
        "toml",
        "dockerfile",
        "gitignore",
        "gitcommit",
      },

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },
    },

    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
