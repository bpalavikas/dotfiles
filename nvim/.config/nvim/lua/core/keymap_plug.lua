local keymap = vim.keymap.set

-- Tmux navigation
keymap("n", "<C-S-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Tmux navigate left" })
keymap("n", "<C-S-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Tmux navigate right" })
keymap("n", "<C-S-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Tmux navigate down" })
keymap("n", "<C-S-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Tmux navigate up" })

-- Gitsigns
keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })
keymap("n", "<leader>gh", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle git blame" })

-- Fugitive
keymap("n", "<leader>gg", "<cmd>topleft G | resize 8<CR>", { desc = "Git status" })


--- Match VS Code search keys
keymap("n", "<leader>sf", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>sg", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
keymap("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fh", function()
  require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find hidden files" })

-- Oil
keymap("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open Oil" })

keymap("n", "<leader>/", function()
  require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
end, { desc = "Toggle comment" })


-- Harpoon: match VS Code
keymap("n", "<leader><leader>a", function()
  require("harpoon"):list():add()
end, { desc = "Harpoon add file" })

keymap("n", "<leader><leader>p", function()
  require("harpoon"):list():prev()
end, { desc = "Harpoon previous" })

-- Keep these too if you like next/previous
keymap("n", "<leader><leader>n", function()
  require("harpoon"):list():next()
end, { desc = "Harpoon next" })

-- Template
keymap("n", "<leader>tt", function()
  require("telescope.builtin").find_files({
    cwd = "~/.config/nvim/FileTemplates",
    prompt_title = "Templates",
  })
end)

-- Insert tab at cursor, like VS Code <leader>t
keymap("n", "<leader>t", "i<Tab><Esc>", { desc = "Insert tab" })

-- Jump to definition in current window
keymap("n", "<leader>gd", vim.lsp.buf.definition, {
  desc = "Goto definition",
})

-- Open definition in split window
keymap("n", "<leader>rd", function()
  vim.cmd("vsplit")
  vim.lsp.buf.definition()
end, {
  desc = "Reveal definition in split",
})

-- Show popup docs/signature/header info
keymap("n", "<leader>sd", vim.lsp.buf.hover, {
  desc = "Show hover documentation",
})
