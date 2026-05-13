return {
  {
    "lewis6991/gitsigns.nvim",

    event = { "BufReadPre", "BufNewFile" },

    opts = {
      signs = {
        add = {
          text = "▎",
        },

        change = {
          text = "▎",
        },

        delete = {
          text = "",
        },

        topdelete = {
          text = "",
        },

        changedelete = {
          text = "▎",
        },
      },

      signs_staged = {
        add = {
          text = "▎",
        },

        change = {
          text = "▎",
        },

        delete = {
          text = "",
        },

        topdelete = {
          text = "",
        },

        changedelete = {
          text = "▎",
        },
      },

      current_line_blame = false,

      preview_config = {
        border = "rounded",
      },
    },
  },
}
