NeoBundle "briancollins/vim-jst"

NeoBundleLazy 'mklabs/vim-backbone', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

NeoBundle 'mxw/vim-jsx'

if executable('node')
  " NeoBundleFetch 'ramitos/jsctags.git', { 'build': {
  "     \   'windows': 'npm install',
  "     \   'cygwin': 'npm install',
  "     \   'mac': 'npm install',
  "     \   'unix': 'npm install --update',
  "     \ }
  " \ }
endif

NeoBundleLazy 'facebook/vim-flow', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}
