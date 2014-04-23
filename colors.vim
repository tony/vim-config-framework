
"===============================================================================
" Quickhl
"===============================================================================

let g:quickhl_colors = [
      \ "gui=bold ctermfg=255 ctermbg=153 guifg=#ffffff guibg=#0a7383",
      \ "gui=bold guibg=#a07040 guifg=#ffffff",
      \ "gui=bold guibg=#4070a0 guifg=#ffffff",
      \ ]


"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
let indent_guides_enable_on_vim_startup = 0
let indent_guides_auto_colors = 0

hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey

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

let g:airline_theme = 'molokai'
let g:indentLine_color_term = 239

filetype plugin indent on
syntax enable

" 256bit terminal
set t_Co=256

if filereadable(expand('~/.vim/bundle/base16-vim/colors/base16-monokai.vim'))
  colorscheme base16-monokai
else
  colorscheme molokai
endif

" molokai: for 256 colors
let g:rehash256 = 1
" Tell Vim to use dark background
set background=dark
