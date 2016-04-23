if executable('python')
  Plug 'davidhalter/jedi-vim', {
        \   'for' : 'python',
        \ }
  "Plug 'tony/python-mode', {
  "      \ 'rev': 'python3',
  Plug 'klen/python-mode', {
        \   'for' : ['python', 'python3', 'djangohtml'],
        \ }

  Plug 'nvie/vim-flake8', {
        \   'for' : ['python', 'python3', 'djangohtml'],
        \ }

  " Plug 'google/yapf', {
  "       \ 'autoload' : {
  "       \   'filetypes' : 'python',
  "       \ },
  "       \ 'build': {
  "       \   'unix': 'pip install --user -e .',
  "       \ },
  "       \ 'rtd': "~/.vim/bundle/yapf/plugins",
  "       \ 'script_type': 'plugin'
  "       \ }

  " Plug 'ehamberg/vim-cute-python', 'moresymbols', {
  "        \   'for' : ['python', 'python3', 'djangohtml'],
  "      \ }
  "     \ 'autoload': {
  "     \   'filetypes': 'python',
  "     \ },
  "     \ 'disabled': !has('conceal'),
  " \ }

  Plug 'tell-k/vim-autopep8', {
        \ 'for' : 'python',
        \ }
  Plug 'Glench/Vim-Jinja2-Syntax'
  Plug 'Vim-scripts/django.vim'

endif
