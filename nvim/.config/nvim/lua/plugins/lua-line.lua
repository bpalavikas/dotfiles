local config = function()
  local theme = require("lualine.themes.gruvbox-material")

  for _, mode in pairs({
    "normal",
    "insert",
    "visual",
    "replace",
    "command",
  }) do
    if theme[mode] and theme[mode].c then
      theme[mode].c.bg = nil
    end
  end

  require("lualine").setup({
    options = {
      theme = theme,
      globalstatus = true,
      component_separators = "",
      section_separators = "",
    },

    sections = {
      lualine_a = { "mode" },

      lualine_b = {
        "branch",
        "diff",
      },

      lualine_c = {
        {
          "filename",
          path = 1,
        },
      },

      lualine_x = {
        "filetype",
      },

      lualine_y = {
        "progress",
      },

      lualine_z = {
        "location",
      },
    },
  })
end

return {
  {
    "nvim-lualine/lualine.nvim",

    event = "VeryLazy",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = config,
  },
}
