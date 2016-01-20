NeoBundleLazy 'scrooloose/syntastic', {
      \ 'autoload': {
      \   'insert': 1,
      \   'filetypes': ['ruby', 'erb'],
      \ }
      \ }

" NeoBundle 'editorconfig/editorconfig-vim' doesn't support scanning project
" upwards for .editorconfig, use dahus
NeoBundle 'dahu/EditorConfig'

NeoBundle 'Konfekt/FastFold'
