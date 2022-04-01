" ------------------------------------------------------------
" Fundamentals
" ------------------------------------------------------------

" init autocmd
autocmd!
" set script encoding
scriptencoding utf-8
" stop loading config if it's on tiny or small
if !1 | finish | endif

set nocompatible
set number
set relativenumber
set mouse=a
set title
set showcmd
set showmatch
set ruler
set encoding=utf-8
set paste
set autoindent
set hlsearch
set cmdheight=1
set backupskip=/tmp/*,/private/tmp/*
set background=dark
set completeopt=longest,menuone
set directory=~/.config/nvim/swap/
set expandtab
set shell=zsh
set noerrorbells
set splitbelow
set splitright
set undodir=~/.config/nvim/undo/
set undofile
set undolevels=1000

" Incremental substitution (neovim)
if has('nvim')
  set inccommand=split
endif

" Suppress appending <PasteStart> and <PasteEnd> when pasting
set t_BE=
set ttyfast

set nosc noru nosm
" Don't redraw while executing macros (good performace config)
set lazyredraw

" When search ignore case
set ignorecase
" Be smart with using tabs
set smarttab
" Indents
filetype plugin indent on
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent
set nowrap
set backspace=start,eol,indent
" Finding file - search down into subfolders
set path+=**
set wildignore+=*/node_modules/*

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

"set list
"set listchars=tab:>-
set conceallevel=3

" Add asterisks in block comments
set formatoptions+=r

" Remove Trailing Whitespace on Save in Vim
autocmd BufWritePre * :%s/\s\+$//e

let g:rainbow_active = 1
" ------------------------------------------------------------
" Imports
" ------------------------------------------------------------
" Mapping
runtime ./maps.vim
" Plugings
runtime ./plug.vim
"runtime ./plugins.vim
" Highlights
runtime ./theme.vim
" MacOS
if has("unix")
    let s:uname = system("uname -s")
    " Do Mac stuff
    if s:uname == "Darwin\n"
        runtime macos.vim
    endif
endif
