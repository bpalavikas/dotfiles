return {
  "numToStr/Comment.nvim",
  enabled = true,
  opts = {},
  config = function(_, opts)
    require("Comment").setup(opts)

vim.keymap.set("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment line" })

vim.keymap.set("v", "<leader>/", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment selection", silent = true })
  end,
}
