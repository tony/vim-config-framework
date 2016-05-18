"Plug 'DarkDefender/clang_complete', {
"      \ 'tag': 'deo_clang_py3',
if !has('nvim')
Plug 'Rip-Rip/clang_complete', {
      \  'for':['c', 'cpp'],
      \}
else
Plug 'zchee/deoplete-clang', {
      \  'for':['c', 'cpp'],
      \}
endif
