" listchar=trail is not as flexible, use the below to highlight trailing
" whitespace. Don't do it for unite windows or readonly files
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup MyAutoCmd
  autocmd BufWinEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
  autocmd InsertEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+\%#\@<!$/ | endif
  autocmd InsertLeave * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
  autocmd BufWinLeave * if &modifiable && &ft!='unite' | call clearmatches() | endif
augroup END


" highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn


filetype plugin indent on
syntax enable

function! ColorSchemeExists(colorscheme)
  try
      exe 'colorscheme' a:colorscheme
      return 1
  catch /^Vim\%((\a\+)\)\=:E185/
      return 0
  endtry
endfunction

if system("ps -o tty= -p $$") =~ "ttyv"
  colorscheme desert
else
  if ColorSchemeExists('molokai')
    colorscheme molokai
    " molokai: for 256 colors
    let g:rehash256 = 1
  else
    colorscheme desert
  endif
endif


if has('gui_running')
  set guifont=Inconsolata-dz\ for\ Powerline:h11
  set transparency=5        " set transparent window
  set guioptions=egmrt  " hide the gui menubar
else
  " Spelling highlights. Use underline in term to prevent cursorline highlights
  " from interfering
  hi clear SpellBad
  hi SpellBad cterm=underline ctermfg=red
  hi clear SpellCap
  hi SpellCap cterm=underline ctermfg=blue
  hi clear SpellLocal
  hi SpellLocal cterm=underline ctermfg=blue
  hi clear SpellRare
  hi SpellRare cterm=underline ctermfg=blue
endif


" Tell Vim to use dark background
set background=dark
