set nocompatible
filetype plugin indent on
syntax on

set termguicolors
set t_Co=256
silent! colorscheme kitty

set number relativenumber
set cursorline
set ruler showcmd laststatus=2
set wildmenu wildmode=longest:full,full
set hidden
set mouse=a
set clipboard=unnamedplus
set scrolloff=4 sidescrolloff=8

set expandtab shiftwidth=4 tabstop=4 softtabstop=4
set autoindent smartindent
set backspace=indent,eol,start

set incsearch hlsearch ignorecase smartcase
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

set splitbelow splitright
set updatetime=300
set undofile
set undodir=~/.vim/undo
silent! call mkdir(expand('~/.vim/undo'), 'p')

let mapleader=" "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
