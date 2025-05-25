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

" Format with <leader>f - now simplified to single autocmd
autocmd FileType * noremap <silent><leader>f :call Preserve("normal gg=G")<CR>

"------------------------------------------------------------------------------
" Data-driven file type settings
"------------------------------------------------------------------------------
" Format: 'filetypes': [shiftwidth, tabstop, expandtab, softtabstop]
" If softtabstop is omitted, it defaults to shiftwidth
" If tabstop is omitted, it defaults to shiftwidth
let s:filetype_settings = {
  \ 'javascript,typescript,typescript.tsx': [2, 2, 1],
  \ 'html,mustache,jst,ejs,erb,handlebars,html.handlebars': [2, 2, 1],
  \ 'html,xhtml,xml,htmldjango,jinja.html,jinja,eruby,mako': [2, 2, 1],
  \ 'css,scss,less': [2, 2, 1],
  \ 'ruby': [2, 2, 1],
  \ 'lua': [2, 2, 1],
  \ 'vim': [2, 8, 1, 2],
  \ 'yaml': [2, 8, 1, 2],
  \ 'sh,csh,tcsh,zsh': [4, 4, 1],
  \ 'python': [4, 4, 1],
  \ 'c,cpp': [4, 4, 1],
  \ 'go': [4, 8, 1, 4],
  \ 'php': [4, 8, 1, 4],
  \ 'rust': [4, 8, 1, 4],
  \ 'rst': [4, 4, 1],
  \ }

" Apply file type settings
for [filetypes, settings] in items(s:filetype_settings)
  let [sw, ts, expand] = settings[0:2]
  let sts = get(settings, 3, sw)
  let ts = get(settings, 1, sw)
  execute printf('autocmd FileType %s setlocal shiftwidth=%d tabstop=%d softtabstop=%d %s',
    \ filetypes, sw, ts, sts, expand ? 'expandtab' : 'noexpandtab')
endfor

" Special settings that don't fit the pattern
autocmd FileType vim setlocal autoindent smarttab keywordprg=:help
autocmd FileType python setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType rst setlocal formatoptions+=nqt textwidth=74
autocmd FileType markdown setlocal textwidth=80
autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
autocmd FileType gitcommit setlocal spell
autocmd FileType gitrebase nnoremap <buffer> S :Cycle<CR>

"------------------------------------------------------------------------------
" File type detection
"------------------------------------------------------------------------------
autocmd BufNewFile,BufRead *.ejs,*.jst setlocal filetype=html.jst
autocmd BufNewFile,BufRead *.handlebars setlocal filetype=html.mustache
autocmd! BufNewFile,BufRead *.js.php set filetype=javascript
autocmd BufNewFile,BufRead *.tmpl,*.jinja,*.jinja2 setlocal ft=jinja.html
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python

"------------------------------------------------------------------------------
" Other autocommands
"------------------------------------------------------------------------------
autocmd BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1

" map :BufClose to :bq and configure it to open a file browser on close
let g:BufClose_AltBuffer = '.'
cnoreabbr <expr> bq 'BufClose'

let javascript_enable_domhtmlcss=1