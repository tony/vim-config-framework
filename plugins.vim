if executable('ag')
  Plug 'rking/ag.vim'
endif

Plug 'qpkorr/vim-bufkill'

" NeoBundle 'editorconfig/editorconfig-vim' doesn't support scanning project
" upwards for .editorconfig, use dahus
" Plug 'dahu/EditorConfig'
Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

if executable('git')
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  let g:EditorConfig_exclude_patterns = ['fugitive://.*']
endif

if executable('go')
  Plug 'fatih/vim-go', {
	\ 'for': 'go'
	\ }
endif


Plug 'tpope/vim-eunuch'

Plug 'sheerun/vim-polyglot'

Plug 'w0rp/ale'

Plug 'tomtom/tcomment_vim'
Plug 'mustache/vim-mustache-handlebars', {
      \   'for': ['html', 'mustache', 'hbs']
      \ }

Plug 'tpope/vim-markdown', {'for':['markdown']}
Plug 'airblade/vim-rooter'
" Heuristically set buffer options
Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'cpp'] }
Plug 'chaoren/vim-wordmotion'

Plug 'tomasr/molokai'
Plug 'rainux/vim-desert-warm-256'

Plug 'Rykka/riv.vim'
