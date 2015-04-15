" http://stackoverflow.com/questions/9990219/vim-whats-the-difference-between-let-and-set
" Borrows from https://github.com/terryma/dotfiles/blob/master/.vimrc
" Borrows from https://github.com/klen/.vim

"" -------------------
" Look and Feel
" -------------------

let g:SESSION_DIR   = $HOME.'/.cache/vim/sessions'

" Don't reset twice on reloading - 'compatible' has SO many side effects.
if !exists('s:loaded_my_vimrc')
  source ~/.vim/bundles.vim
  source ~/.vim/functions.vim
  source ~/.vim/quickfix.vim
  source ~/.vim/settings.vim
  source ~/.vim/autocmd.vim
  source ~/.vim/keymappings.vim

  for fpath in split(globpath('~/.vim/settings/', '*.vim'), '\n')
    exe 'source' fpath
  endfor
  source ~/.vim/ignore.vim
endif

" from functions.vim
com! -nargs=0 SeeTab :call SeeTab()



" Cursor settings. This makes terminal vim sooo much nicer!
" Tmux will only forward escape sequences to the terminal if surrounded by a DCS
" sequence
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


"===============================================================================
" Local Settings
"===============================================================================


"au CursorHoldI * stopinsert  " go back into normal mode in 4 seconds

source ~/.vim/colors.vim

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

if !exists('s:loaded_my_vimrc')
  let s:loaded_my_vimrc = 1
endif

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

if has('nvim')
  runtime! plugin/python_setup.vim
endif

if filereadable(expand("/usr/src/tools/tools/editing/freebsd.vim"))
  source /usr/src/tools/tools/editing/freebsd.vim
endif
