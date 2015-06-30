if executable('ruby')
  " NeoBundleLazy 'bbommarito/vim-slim'
  NeoBundleLazy 'slim-template/vim-slim'
  NeoBundleLazy 'wavded/vim-stylus'
  if executable('ruby')
    NeoBundleLazy 'vim-ruby/vim-ruby', {
          \ 'autoload' : {
          \   'filetypes' : 'ruby',
          \ }}
    NeoBundleLazy 'tpope/rbenv-ctags', {
          \ 'autoload' : {
          \   'filetypes' : 'ruby',
          \ }}
    NeoBundleLazy 'tpope/vim-rbenv', {
          \ 'autoload' : {
          \   'filetypes' : 'ruby',
          \ }}
  endif

endif
