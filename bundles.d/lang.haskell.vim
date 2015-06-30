"
"" haskell
"
if executable('ghc-mod')
  NeoBundleLazy 'dag/vim2hs', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}


  NeoBundleLazy 'eagletmt/ghcmod-vim', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}

  NeoBundleLazy 'ujihisa/neco-ghc', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}

  NeoBundleLazy 'Twinside/vim-hoogle', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}

  NeoBundleLazy 'carlohamalainen/ghcimportedfrom-vim', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}
endif
