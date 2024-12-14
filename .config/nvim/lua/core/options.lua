-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Vim options
-- 
local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true
opt.numberwidth = 1

-- tabs indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smarttab = true
opt.scrolloff = 5
opt.list = true
opt.cindent = true

--line wrapping 
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- appearance
opt.cursorline = true
opt.cmdheight = 1
opt.mouse = 'a'
opt.termguicolors = true
opt.colorcolumn = '80'
opt.signcolumn 	= "yes"
opt.showtabline = 2
opt.showmode = true
opt.showcmd = true
opt.showmatch = true
opt.laststatus = 2
opt.pumheight = 10


-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append('unnamedplus')

-- split windows
opt.splitright = true
opt.splitbelow = true

-- backups
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.writebackup = false
