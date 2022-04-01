" ------------------------------------------------------------
" Nerd Tree
" ------------------------------------------------------------
let g:NERDTreeHijackNetrw=0
let g:NERDTreeMinimalUI  = 1
let g:NERDTreeDirArrows  = 1
let g:NERDTreeShowHidden = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeWinSize  = 40
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
let g:NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusShowIgnored = 1
let g:NERDTreeGitStatusUntrackedFilesMode = 'normal'
let g:NERDTreeGitStatusShowClean = 1
let g:NERDTreeFileExtensionHighlightFullName = 0

let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ' '
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 0
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:webdevicons_enable_nerdtree = 1
let g:loaded_vim_nerdtree_syntax_highlight = 1

autocmd FileType nerdtree setlocal nolist

"autocmd StdinReadPre * let s:std_in=1
augroup nerdtree
  autocmd!
  autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

  autocmd BufWinEnter * silent NERDTreeMirror
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
augroup END
"
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Ignored"   : "☒",
    \ "Unknown"   : "?"
    \ }


map <C-n> :NERDTreeToggle<CR>
"map <C-j> :NERDTreeFocus<CR>
"map <C-l> :NERDTreeFocusToggle<CR>
map <C-p> :Files<CR>

" Window Navigation with Ctrl-[hjkl]
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l