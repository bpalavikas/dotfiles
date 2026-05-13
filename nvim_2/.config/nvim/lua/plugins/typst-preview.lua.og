return {
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    config = function()
      require("typst-preview").setup({
        backend = "tinymist",
        dependencies_bin = {
          tinymist = vim.fn.exepath("tinymist"),
          websocat = nil,
        },
      })

      -- Optional keymap to toggle preview
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        callback = function()
          vim.keymap.set("n", "<leader>tp", ":TypstPreviewToggle<CR>", { buffer = true, desc = "Toggle Typst Preview" })
        end,
      })
    end,
  },
}
