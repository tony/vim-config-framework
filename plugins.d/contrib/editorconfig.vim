" NeoBundle 'editorconfig/editorconfig-vim' doesn't support scanning project
" upwards for .editorconfig, use dahus
" Plug 'dahu/EditorConfig'

Plug 'editorconfig/editorconfig-vim'

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
