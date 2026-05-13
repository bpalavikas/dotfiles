return {
  {
    "nvim-telescope/telescope.nvim",

    branch = "0.1.x",

    cmd = "Telescope",

    dependencies = {
      "nvim-lua/plenary.nvim",

      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },

    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",

          path_display = {
            "smart",
          },

          file_ignore_patterns = {
            ".git/",
            "node_modules/",
            "build/",
            "dist/",
          },

          layout_strategy = "horizontal",

          sorting_strategy = "ascending",

          layout_config = {
            prompt_position = "top",
          },
        },

        pickers = {
          find_files = {
            theme = "ivy",
            hidden = true,
          },

          live_grep = {
            theme = "ivy",
          },

          buffers = {
            theme = "ivy",
          },
        },

        extensions = {
          fzf = {
            fuzzy = true,

            override_generic_sorter = true,
            override_file_sorter = true,

            case_mode = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  },
}
