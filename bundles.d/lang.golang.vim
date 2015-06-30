if executable('go')
  NeoBundleLazy "nsf/gocode", {
        \ 'autoload': {'filetypes': ['go']}
        \ }
  NeoBundleLazy "fatih/vim-go", {
        \ 'autoload': {'filetypes': ['go']}}
  NeoBundleLazy "jstemmer/gotags", {
        \ 'autoload': {'filetypes': ['go']}}
endif

