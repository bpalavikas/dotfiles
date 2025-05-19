return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("noice").setup({
      cmdline = {
        enabled = true,
        view = "cmdline_popup",
      },
      messages = {
        enabled = false,
      },
      popupmenu = {
        enabled = false,
      },
      notify = {
        enabled = false,
      },
      lsp = {
        progress = { enabled = false },
        signature = { enabled = false },
        hover = { enabled = false },
        message = { enabled = false },
      },
      presets = {
        command_palette = false,
        long_message_to_split = false,
        inc_rename = false,
        lsp_doc_border = false,
      },
    })
  end,
}
