colorscheme slate
" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn on syntax highlighting.
syntax on


" Configs
set number
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set smarttab
set relativenumber
set cursorline
set nobackup
set scroll=10
set nowrap
set incsearch
set hlsearch
set smartcase
set showcmd
set showmatch
set showmode


" Key Mappings
" set leader key as space
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader><leader>q :q!<CR>
nnoremap <leader><leader>w :wq<CR>

nnoremap <leader>j o<esc>
nnoremap <leader>k O<esc>

imap jj <esc>

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l











