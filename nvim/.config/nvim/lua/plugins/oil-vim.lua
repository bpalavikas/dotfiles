return {
  {
    "stevearc/oil.nvim",

    cmd = {
      "Oil",
    },

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      default_file_explorer = true,

      columns = {
        "icon",
      },

      view_options = {
        show_hidden = true,
      },

      float = {
        border = "rounded",
      },
    },
  },
}
