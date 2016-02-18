if executable('go')
  NeoBundleLazy "nsf/gocode", {
        \ 'autoload': {'filetypes': ['go']},
        \ 'rtp': 'vim/'
        \ }
  NeoBundleLazy "fatih/vim-go", {
        \ 'autoload': {'filetypes': ['go']}}
  NeoBundleLazy "zchee/deoplete-go", {
      \ 'autoload': {'filetypes': ['go']}
  \ }
endif

