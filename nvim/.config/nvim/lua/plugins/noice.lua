return {
  {
    "folke/noice.nvim",

    event = "VeryLazy",

    dependencies = {
      "MunifTanjim/nui.nvim",
    },

    opts = {
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },

      messages = {
        enabled = true,
      },

      popupmenu = {
        enabled = false,
      },

      notify = {
        enabled = false,
      },

      lsp = {
        progress = {
          enabled = false,
        },

        signature = {
          enabled = true,
        },

        hover = {
          enabled = true,
        },

        message = {
          enabled = false,
        },
      },

      presets = {
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
}
