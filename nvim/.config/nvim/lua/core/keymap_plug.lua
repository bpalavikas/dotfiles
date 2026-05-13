local keymap = vim.keymap.set

-- Tmux navigation
keymap("n", "<C-S-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Tmux navigate left" })
keymap("n", "<C-S-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Tmux navigate right" })
keymap("n", "<C-S-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Tmux navigate down" })
keymap("n", "<C-S-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Tmux navigate up" })

-- Gitsigns
keymap("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })
keymap("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle git blame" })

-- Fugitive
keymap("n", "<leader>g", "<cmd>topleft G | resize 8<CR>", { desc = "Git status" })

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
keymap("n", "<leader>fs", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fh", function()
  require("telescope.builtin").find_files({ hidden = true })
end, { desc = "Find hidden files" })

-- Oil
keymap("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open Oil" })

keymap("n", "<leader>/", function()
  require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
end, { desc = "Toggle comment" })


-- Harpoon
keymap("n", "<leader><leader>m", function()
  require("harpoon"):list():add()
end, { desc = "Harpoon add file" })

keymap("n", "<leader><leader>h", function()
  local harpoon = require("harpoon")
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })

keymap("n", "<leader><leader>j", function()
  require("harpoon"):list():prev()
end, { desc = "Harpoon previous" })

keymap("n", "<leader><leader>k", function()
  require("harpoon"):list():next()
end, { desc = "Harpoon next" })
