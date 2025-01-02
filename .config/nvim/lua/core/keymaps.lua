-- KEYMAPS

-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

-- General Keymaps
--new line stay in normal mode
keymap.set("n", "<leader>j", "o<ESC>")
keymap.set("n", "<leader>k", "O<ESC>")

-- move current line up 1 down 1
keymap.set("n", "<A-j>", ":m +1<CR>==",{desc = "move line 1 down"})
keymap.set("n", "<A-k>", ":m -2<CR>==",{desc = "move line 1 up"})

keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv",{desc = "move selected lines 1 down"})
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv",{desc = "move selected lines 1 up"})

-- saving and new file and quitting 
keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap.set("n", "<leader><leader>q", ":q!<CR>", { desc = "Quit without saving" })
keymap.set("n", "<leader>w", ":w<CR>")
keymap.set("n", "<leader><leader>w", ":wq<CR>")

keymap.set("i", "jj", "<ESC>")

-- indenting
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Commenting out code _> is ment to be /
-- keymap.set("n", "<C-_>", "gcc", {noremap = false})
-- keymap.set("v", "<C-_>", "gc", {noremap = false})
vim.keymap.set('n', 'c/', ':normal gcc<CR><DOWN>', { desc = '[/] Toggle comment line' })
vim.keymap.set('v', 'c/', '<Esc>:normal gvgc<CR>', { desc = '[/] Toggle comment block' })

-- clear search highlights
keymap.set("n", "<leader>ch", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Tabs
keymap.set("n", "<leader>nt", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>ct", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>u", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader><leader>u", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>mt", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- -- Tmux window managment
keymap.set("n", "<C-S>h", "<cmd>TmuxNavigateLeft<CR>")
keymap.set("n", "<C-S>l", "<cmd>TmuxNavigateRight<CR>")
keymap.set("n", "<C-S>j", "<cmd>TmuxNavigateDown<CR>")
keymap.set("n", "<C-S>k", "<cmd>TmuxNavigateUp<CR>")

-- Git signs
keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {})

-- Git fugitive
vim.api.nvim_set_keymap('n', '<leader>g', ':topleft G<CR> :resize 8<CR>', { noremap = true, silent = true })

-- set telescope keybinds
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
keymap.set("n", "<leader>fh", function()require('telescope.builtin').find_files({ hidden = true })end, { desc = "Find files, including hidden ones" })

-- Oil keybinds
keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open Oil" })

-- set harpoon keybinds
keymap.set("n", "<leader><leader>m", ":lua require('harpoon.mark').add_file()<cr>",{ desc = "Mark file with harpoon" })
keymap.set("n", "<leader><leader>k", ":lua require('harpoon.ui').nav_next()<cr>", { desc = "Go to next harpoon mark" })
keymap.set("n", "<leader><leader>j", ":lua require('harpoon.ui').nav_prev()<cr>",{ desc = "Go to previous harpoon mark" })
keymap.set("n", "<leader><leader>h", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", {desc = "toggle menu"})

-- Buffer management
vim.api.nvim_set_keymap("n", "<leader><leader>d", ":bd<CR>", {noremap = false}) -- close current buffer
vim.api.nvim_set_keymap("n", "<leader><leader>f", ":bp<CR>", {noremap = false}) -- go to previous buffer
vim.api.nvim_set_keymap("n", "<leader><leader>g", ":bn<CR>", {noremap = false}) -- go to next buffer
keymap.set("n", "<leader><leader>nb", ":e") -- New buffer
keymap.set("n", "<leader><leader>lb", ":ls") -- List the buffers

keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

