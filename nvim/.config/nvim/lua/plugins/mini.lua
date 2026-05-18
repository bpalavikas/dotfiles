return {
  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",

    config = function()
      require("mini.ai").setup()

      require("mini.comment").setup()

      -- require("mini.pairs").setup()

      require("mini.indentscope").setup({
        symbol = "│",
      })

      -- require("mini.notify").setup()

      require("mini.icons").setup()

      require("mini.trailspace").setup()
    end,
  },
}
