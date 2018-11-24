if executable('ag')
  Plug 'rking/ag.vim'
endif

Plug 'wincent/ferret'

Plug 'qpkorr/vim-bufkill'

" NeoBundle 'editorconfig/editorconfig-vim' doesn't support scanning project
" upwards for .editorconfig, use dahus
Plug 'dahu/EditorConfig'

Plug 'tpope/vim-sleuth'

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

Plug 'rainux/vim-desert-warm-256'

Plug 'Rykka/riv.vim'

Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif


if executable('black')
  Plug 'ambv/black'
  autocmd BufWritePre *.py execute ':Black'
  " https://github.com/ambv/black/issues/414
  let g:black_skip_string_normalization = 1
endif

if executable('isort')
  " isort not being found: https://github.com/fisadev/vim-isort/issues/29
  Plug 'fisadev/vim-isort'
  autocmd BufWritePre *.py execute ':Isort'
endif

if executable('node')
  " post install (yarn install | npm install) then load plugin only for editing supported files
  Plug 'prettier/vim-prettier', {
    \ 'do': 'yarn install',
    \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }

  autocmd BufWritePre *.ts,*.tsx,*.js,*.jsx execute ':Prettier'
endif
