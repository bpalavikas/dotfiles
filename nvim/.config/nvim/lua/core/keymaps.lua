local keymap = vim.keymap.set

-- New line without staying in insert mode
keymap("n", "<leader>j", "o<Esc>", { desc = "New line below" })
keymap("n", "<leader>k", "O<Esc>", { desc = "New line above" })

-- Move current line
keymap("n", "<A-j>", ":m +1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", ":m -2<CR>==", { desc = "Move line up" })

-- Move selected lines
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Save / quit
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
keymap("n", "<leader><leader>q", "<cmd>q!<CR>", { desc = "Quit without saving" })
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Write file" })
keymap("n", "<leader><leader>w", "<cmd>wq<CR>", { desc = "Write and quit" })

-- Indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Clear search highlights
keymap("n", "<leader>ch", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Delete character without copying into register
keymap("n", "x", '"_x', { desc = "Delete character without yanking" })

-- Increment / decrement numbers
keymap("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Window management
keymap("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
keymap("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Tabs
keymap("n", "<leader>nt", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>ct", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader>u", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader><leader>u", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "<leader>mt", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Buffer management
keymap("n", "<leader><leader>d", "<cmd>bd<CR>", { desc = "Delete buffer" })
keymap("n", "<leader><leader>f", "<cmd>bp<CR>", { desc = "Previous buffer" })
keymap("n", "<leader><leader>g", "<cmd>bn<CR>", { desc = "Next buffer" })
keymap("n", "<leader><leader>nb", ":e ", { desc = "Edit file" })
keymap("n", "<leader><leader>lb", "<cmd>ls<CR>", { desc = "List buffers" })

-- Source current file
keymap("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source current file" })
