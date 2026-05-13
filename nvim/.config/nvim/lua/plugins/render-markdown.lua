return {
  {
    "MeanderingProgrammer/render-markdown.nvim",

    ft = {
      "markdown",
    },

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim",
    },

    opts = {
      heading = {
        enabled = true,
      },

      bullet = {
        enabled = true,
      },

      checkbox = {
        enabled = true,
      },

      code = {
        enabled = true,
        sign = false,
        width = "block",
      },

      pipe_table = {
        enabled = true,
      },
    },
  },
}
