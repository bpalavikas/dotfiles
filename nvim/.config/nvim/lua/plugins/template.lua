return {
  "nvimdev/template.nvim",
  config = function()
    require("template").setup({
    temp_dir = "~/.config/nvim/FileTemplates",
      author = "Byron",
    })
  end,
}
