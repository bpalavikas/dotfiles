-- Set up core section
require("core.globals")
require("core.options")
require("core.keymaps")
-- Packet manager
require("config.statusline")
require("config.vimpack")
-- Set the colour theme
vim.opt.termguicolors = true
vim.cmd.colorscheme('gruvbox-material')
