if executable('ag')
  Plug 'rking/ag.vim', { 'on': ['Ag'] }
endif

Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

Plug 'chriskempson/base16-vim'
Plug 'qpkorr/vim-bufkill'

Plug 'rhysd/vim-clang-format', {
	\ 'for': ['c', 'cpp']
      \}
" [sudo] gem install CoffeeTags
Plug 'lukaszkorecki/CoffeeTags', {
  \ 'for':['coffee', 'haml'],
\}

Plug 'octol/vim-cpp-enhanced-highlight',
	\ { 'for': 'cpp' }
Plug 'hail2u/vim-css3-syntax', {
      \   'for' : ['css', 'less'],
      \}

" Note: despite the name, vim-haml provides Haml, Sass, and SCSS
Plug 'tpope/vim-haml', {
      \   'for' : 'scss',
      \ }

" NeoBundle 'editorconfig/editorconfig-vim' doesn't support scanning project
" upwards for .editorconfig, use dahus
" Plug 'dahu/EditorConfig'

Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

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

Plug 'othree/html5-syntax.vim', {
      \     'for' : ['html', 'xhtml', 'jst', 'ejs']
      \   }
if executable('i3')
  Plug 'PotatoesMaster/i3-vim-syntax', {
	\ 'for': 'i3'
        \ }
endif

Plug 'posva/vim-vue'
Plug 'mxw/vim-jsx'

Plug 'elzr/vim-json', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}


Plug 'pangloss/vim-javascript', {
      \ 'autoload' : {
      \   'filetypes' : ['javascript', 'jsx']
      \ }}

Plug 'tpope/vim-eunuch', {
      \   'on': [
      \     'Unlink',
      \     'Remove',
      \     'Move',
      \     'Rename',
      \     'Chmod',
      \     'Mkdir',
      \     'Find',
      \     'Locate',
      \     'SudoEdit',
      \     'SudoWrite',
      \     'W'
      \   ],
      \}

if executable('python')
  Plug 'klen/python-mode', {
        \ 'branch': 'develop',
        \   'for' : ['python', 'python3', 'djangohtml'],
        \ }

  Plug 'Glench/Vim-Jinja2-Syntax'
  Plug 'Vim-scripts/django.vim'

  Plug 'fisadev/vim-isort'
endif

Plug 'w0rp/ale'

" Conflicts with airline (race condition loading)
" Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'tomtom/tcomment_vim'
Plug 'mustache/vim-mustache-handlebars', {
      \   'for': ['html', 'mustache', 'hbs']
      \ }

Plug 'tpope/vim-markdown', {'for':['markdown']}
Plug 'airblade/vim-rooter'
" Heuristically set buffer options
Plug 'tpope/vim-sleuth'
Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'cpp'] }
Plug 'chaoren/vim-wordmotion'
Plug 'bkad/CamelCaseMotion'
Plug 'avakhov/vim-yaml', { 'for': 'yaml' }
