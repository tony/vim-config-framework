"===============================================================================
" Autocommands
"===============================================================================

function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Set augroup
augroup MyAutoCmd
  autocmd!
augroup END

" Redraw since vim gets corrupt for no reason
au FocusGained * redraw! " redraw screen on focus

autocmd MyAutoCmd FileType json setlocal syntax=javascript

autocmd FileType * noremap <silent><leader>f :call Preserve("normal gg=G")<CR>
autocmd FileType javascript noremap <silent><leader>f :call Preserve("normal gg=G")<CR>
autocmd FileType html,mustache,jinja,hbs,handlebars,html.handlebars noremap <silent><leader>f :call Preserve("normal gg=G")<CR>

autocmd FileType ejs,jst noremap <silent><leader>f :call Preserve("normal gg=G")<CR>
autocmd FileType less, scss, sass noremap <silent><leader>f :call Preserve("normal gg=G")<CR>

autocmd BufNewFile,BufRead *.ejs,*.jst setlocal filetype=html.jst  " https://github.com/briancollins/vim-jst/blob/master/ftdetect/jst.vim
autocmd BufNewFile,BufRead *.handlebars setlocal filetype=html.mustache
autocmd! BufNewFile,BufRead *.js.php,*.json set filetype=javascript
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType vim setlocal autoindent expandtab smarttab shiftwidth=2 softtabstop=2 keywordprg=:help
autocmd FileType html,mustache,jst,ejs,erb,handlebars,html.handlebars setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

autocmd FileType sh,csh,tcsh,zsh setlocal autoindent expandtab smarttab shiftwidth=4 softtabstop=4
autocmd BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1

autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
autocmd FileType gitcommit setlocal spell
autocmd FileType gitrebase nnoremap <buffer> S :Cycle<CR>

" map :BufClose to :bq and configure it to open a file browser on close
let g:BufClose_AltBuffer = '.'
cnoreabbr <expr> bq 'BufClose'

autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNewFile,BufRead *.go setlocal ft=go
autocmd FileType go setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4
autocmd FileType php setlocal shiftwidth=4 tabstop=8 softtabstop=4 expandtab
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType html,xhtml,xml,htmldjango,jinja.html,jinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNewFile,BufRead *.tmpl,*.jinja,*.jinja2 setlocal ft=jinja.html
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python

autocmd FileType css,scss,less setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

autocmd FileType rst setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 formatoptions+=nqt textwidth=74
autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2
autocmd FileType javascript,typescript,typescript.tsx setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNewFile,BufRead *.json setlocal ft=javascript
let javascript_enable_domhtmlcss=1
autocmd BufNewFile,BufRead CMakeLists.txt setlocal ft=cmake
autocmd FileType yaml setlocal expandtab shiftwidth=2 tabstop=8 softtabstop=2
autocmd FileType lua setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType markdown setlocal textwidth=80
autocmd FileType rust setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4
