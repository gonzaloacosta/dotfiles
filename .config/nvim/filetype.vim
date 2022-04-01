" ------------------------------------------------------------
" File types
" ------------------------------------------------------------
au BufNewFile,BufRead *.es6 setf javascript
au BufNewFile,BufRead *.tsx setf typescriptreact
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.flow set filetype=javascript
au BufNewFile,BufRead *.py set filetype=python
au BufNewFile,BufRead *.tf set filetype=terraform
au BufNewFile,BufRead *.yaml set filetype=yaml
au BufNewFile,BufRead *.yml set filetype=yaml
au BufNewFile,BufRead Jenkinsfile set filetype=groovy
au BufNewFile,BufRead Makefile set filetype=make

set suffixesadd=.es6,tsx,.js,.json,.css,.less,.sass,.styl,.php,.py,.md,.yaml,.yml,Jenkinsfile,.tf,Makefile

autocmd FileType yaml setlocal sts=2 ts=2 sw=2 expandtab
autocmd FileType python setlocal sts=4 ts=4 sw=4 expandtab
autocmd FileType groovy setlocal sts=4 ts=4 sw=4 expandtab
autocmd FileType terraform setlocal sts=4 ts=4 sw=4 expandtab
autocmd FileType make setlocal sts=4 ts=4 sw=4 expandtab