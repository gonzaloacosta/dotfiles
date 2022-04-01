" ------------------------------------------------------------
" Plug
" ------------------------------------------------------------
call plug#begin('~/.config/nvim/plug')

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-markdown'

if has("nvim")
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kristijanhusak/defx-git'
  Plug 'kristijanhusak/defx-icons'
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'neovim/nvim-lspconfig'
  Plug 'tami5/lspsaga.nvim', { 'branch': 'nvim6.0' }
  Plug 'folke/lsp-colors.nvim'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'onsails/lspkind-nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'windwp/nvim-autopairs'
  Plug 'windwp/nvim-ts-autotag'
  Plug 'navarasu/onedark.nvim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'preservim/nerdtree' |
      \ Plug 'jistr/vim-nerdtree-tabs' |
      \ Plug 'ryanoasis/vim-devicons' |
      \ Plug 'tiagofumo/vim-nerdtree-syntax-highlight' |
      \ Plug 'preservim/nerdcommenter' |
      \ Plug 'Xuyuanp/nerdtree-git-plugin'
  "  " Python
  "  Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
  "  Plug 'Vimjas/vim-python-pep8-indent'
  "  Plug 'dense-analysis/ale'
  "  Plug 'davidhalter/jedi'
  Plug 'hashivim/vim-terraform'
  Plug 'fatih/vim-hclfmt'
  "  Plug 'lepture/vim-jinja'
  Plug 'Yggdroot/indentLine'
  Plug 'stephpy/vim-yaml'
  Plug 'pedrohdz/vim-yaml-folds'
  "  Plug 'towolf/vim-helm'
endif

call plug#end()
