NeoBundle "briancollins/vim-jst"

NeoBundleLazy 'mklabs/vim-backbone', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

NeoBundleLazy 'mxw/vim-jsx', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

if executable('node')
  " NeoBundleFetch 'ramitos/jsctags.git', { 'build': {
  "     \   'windows': 'npm install',
  "     \   'cygwin': 'npm install',
  "     \   'mac': 'npm install',
  "     \   'unix': 'npm install --update',
  "     \ }
  " \ }
endif
