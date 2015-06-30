if executable('java')
  NeoBundleLazy 'tpope/vim-classpath', {
        \ 'autoload': {
        \   'filetypes': ['java', 'clojure']
        \ }
        \}
endif

