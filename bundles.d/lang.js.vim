NeoBundleLazy 'Shutnik/jshint2.vim'

NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls','ty']}}

NeoBundleLazy 'elzr/vim-json', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}


NeoBundleLazy 'pangloss/vim-javascript', {
      \ 'autoload' : {
      \   'filetypes' : ['javascript', 'jsx']
      \ }}

if executable('node')
  NeoBundleLazy 'marijnh/tern_for_vim', { 'build': {
        \   'windows': 'npm install',
        \   'cygwin': 'npm install',
        \   'mac': 'npm install',
        \   'unix': 'npm install',
        \ },
        \ 'autoload' : {
        \   'filetypes' : 'javascript',
        \ }
        \ }

  NeoBundleLazy 'maksimr/vim-jsbeautify', {
        \ 'autoload' : {
        \   'filetypes' : ['javascript', 'html', 'mustache', 'css', 'less', 'jst']
        \ }}


  NeoBundleFetch 'einars/js-beautify' , {
        \   'build' : {
        \       'unix' : 'npm install --update',
        \   },
        \}

  NeoBundleFetch 'ramitos/jsctags', { 'build': {
      \   'windows': 'npm install',
      \   'cygwin': 'npm install',
      \   'mac': 'npm install',
      \   'unix': 'npm install --update',
      \ }
  \ }
endif

if executable('tsc')
  NeoBundle 'Quramy/tsuquyomi'

  NeoBundle 'leafgarland/typescript-vim'
endif
