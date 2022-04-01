" ------------------------------------------------------------
" Highlights
" ------------------------------------------------------------
set cursorline
"set cursorcolumn

" Set cursor line color on visual mode
highlight Visual cterm=NONE ctermbg=236 ctermfg=NONE guibg=Grey40
highlight LineNr cterm=none ctermfg=240 guifg=#2b506e guibg=#000000

augroup BgHighlight
    autocmd!
    autocmd WinEnter * set cul
    autocmd WinLeave * set nocul
augroup END

if &term =~ "screen"
    autocmd BufEnter * if bufname("") !~ "^?[A-Za-z0-9?]*://" | silent! exe '!echo -n "\ek[`hostname`:`basename $PWD`/`basename %`]\e\\"' | endif
    autocmd VimLeave * silent!  exe '!echo -n "\ek[`hostname`:`basename $PWD`]\e\\"'
endif

" ------------------------------------------------------------
" Syntax theme
" ------------------------------------------------------------
" true color
if exists("&termguicolors") && exists("&winblend")
    colorscheme onedark
    let g:onedark_style = 'darker'
    let g:onedark_hide_endofbuffer = 1
    let g:onedar_termcolor = 256
    let g:airline_theme = 'onedark'
    let g:onedark_italic_comment = v:true
    let g:onedark_transparent_background = v:true
    if (has("autocmd") && !has("gui_running"))
        augroup colorset
            autocmd!
            let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
            autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
        augroup END
    endif

    highlight Normal       guibg=NONE ctermbg=NONE
    highlight NonText      guibg=NONE ctermbg=NONE
    highlight EndOfBuffer  guibg=NONE ctermbg=NONE
    highlight Folded       guibg=NONE ctermbg=NONE
    highlight LineNr       guibg=NONE ctermbg=NONE
    highlight CursorLineNr guibg=NONE ctermbg=NONE
    highlight SpecialKey   guibg=NONE ctermbg=NONE

endif