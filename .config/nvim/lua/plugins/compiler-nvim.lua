return {
    { -- This plugin
      "Zeioth/compiler.nvim",
      cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
      dependencies = {
        "stevearc/overseer.nvim",
        "nvim-telescope/telescope.nvim"
      },
      opts = {}, -- Compiler.nvim options (if any)
    },
    { -- The task runner
      "stevearc/overseer.nvim",
      cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
      opts = {
        task_list = {
          direction = "bottom",
          min_height = 25,
          max_height = 25,
          default_detail = 1
        },
      },
    },
}
