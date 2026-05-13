local config = function()
  local theme = require("lualine.themes.gruvbox-material")

  for _, mode in pairs({ "normal", "insert", "visual", "replace", "command" }) do
    if theme[mode] and theme[mode].c then
      theme[mode].c.bg = nil
    end
  end

    require('lualine').setup({
        options = {
            theme = theme,
            globalstatus = true,
        },
        sections = {
            lualine_a = {"mode"},
            lualine_b = {"buffers"},
            lualine_x = {"filetype"},
            lualine_y = {"progress", "selectioncount"},
            lualine_z = {"branch"},
        },
    })

end

return{
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "akinsho/bufferline.nvim",
    },
    config = config,
}
