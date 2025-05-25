" Simplified highlight settings

" Show trailing whitespace using list/listchars
set list
set listchars=tab:▸\ ,trail:·,extends:»,precedes:«,nbsp:+

" Dark background
set background=dark

" Simple spell highlighting for terminal
if !has('gui_running')
  hi clear SpellBad
  hi SpellBad cterm=underline ctermfg=red
endif