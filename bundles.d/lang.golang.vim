if executable('go')
  NeoBundleLazy "nsf/gocode", {
        \ 'autoload': {'filetypes': ['go']}
        \ }
  NeoBundleLazy "fatih/vim-go", {
        \ 'autoload': {'filetypes': ['go']}}
endif

