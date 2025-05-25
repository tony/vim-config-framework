" filetype and syntax are handled in vimrc
" autoindent and backspace are set in sensible.vim

set foldenable                  " Auto fold code

" wildmenu is set in sensible.vim
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.

set showmatch                   " Show matching brackets/parenthesis
" incsearch is set in sensible.vim
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present

if has('cmdline_info')
    " ruler is set in sensible.vim
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
                                " Selected characters/lines in visual mode
endif

" Statusline configuration removed - use default or plugin statuslines

" noswapfile is already set in vimrc
" vim-rooter handles directory changes, so we don't need autocmd BufEnter

"------------------------------------------------------------------------------
" Highlight Settings (from highlight.vim)
"------------------------------------------------------------------------------
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
