if executable('python')
  NeoBundleLazy 'davidhalter/jedi-vim', {
        \   'autoload' : {
        \     'filetypes': 'python',
        \   },
        \ }

  NeoBundleLazy 'klen/python-mode', {
        \ 'autoload' : {
        \   'filetypes' : 'python',
        \ }}

  " NeoBundleLazy 'google/yapf', {
  "       \ 'autoload' : {
  "       \   'filetypes' : 'python',
  "       \ },
  "       \ 'build': {
  "       \   'unix': 'pip install --user -e .',
  "       \ },
  "       \ 'rtd': "~/.vim/bundle/yapf/plugins",
  "       \ 'script_type': 'plugin'
  "       \ }

  " NeoBundleLazy 'ehamberg/vim-cute-python', 'moresymbols', {
  "     \ 'autoload': {
  "     \   'filetypes': 'python',
  "     \ },
  "     \ 'disabled': !has('conceal'),
  " \ }

  NeoBundleLazy 'tell-k/vim-autopep8', {
        \ 'autoload' : {
        \   'filetypes' : 'python',
        \ }}
  NeoBundle "Glench/Vim-Jinja2-Syntax"
  NeoBundle "Vim-scripts/django.vim"

endif
