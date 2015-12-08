if executable('go')
  NeoBundleLazy "nsf/gocode", {
        \ 'autoload': {'filetypes': ['go']},
        \ 'disabled' : !has('nvim')
        \ }
  NeoBundleLazy "fatih/vim-go", {
        \ 'autoload': {'filetypes': ['go']}}
  NeoBundleLazy "zchee/deoplete-go", {
      \ 'autoload': {'filetypes': ['go']},
      \ 'disabled' : has('nvim')
  \ }
endif

