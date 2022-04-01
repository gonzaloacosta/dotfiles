" From VIM
" profile start profile.log
" profile func *
" profile file *
" " At this point do slow actions
" profile pause
" noautocmd qall!


" From terminal
" vim -V <file_open>

" From terminal
"vim --cmd 'profile start profile.log' \
"    --cmd 'profile func *' \
"    --cmd 'profile file *' \
"    -c 'profdel func *' \
"    -c 'profdel file *' \
"    -c 'qa!'
