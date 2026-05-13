return {
  {
    "folke/todo-comments.nvim",

    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    opts = {
      signs = true,

      keywords = {
        TODO = {
          icon = " ",
        },

        FIX = {
          icon = " ",
        },

        HACK = {
          icon = " ",
        },

        WARN = {
          icon = " ",
        },

        NOTE = {
          icon = "󰋽 ",
        },
      },
    },
  },
}
