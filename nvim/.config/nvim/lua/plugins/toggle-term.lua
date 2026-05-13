return {
  {
    "akinsho/toggleterm.nvim",

    version = "*",

    cmd = {
      "ToggleTerm",
      "TermExec",
    },

    keys = {
      {
        "<C-\\>",
        "<cmd>ToggleTerm<CR>",
        desc = "Toggle terminal",
      },
    },

    opts = {
      size = 15,

      open_mapping = [[<C-\>]],

      hide_numbers = true,

      shade_terminals = true,
      shading_factor = 2,

      start_in_insert = true,
      insert_mappings = true,

      persist_size = true,
      persist_mode = true,

      direction = "horizontal",

      close_on_exit = true,

      shell = vim.o.shell,

      float_opts = {
        border = "rounded",
      },
    },
  },
}
