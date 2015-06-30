if executable('git')

  NeoBundleLazy 'airblade/vim-gitgutter'
  NeoBundle 'tpope/vim-fugitive', {
        \ 'autoload' : {'commands': 
        \   ['Gwrite', 'Gcommit', 'Gmove', 'Ggrep', 'Gbrowse', 'Glog',
        \    'Git', 'Gedit', 'Gsplit', 'Gvsplit', 'Gtabedit', 'Gdiff',
        \    'Gstatus', 'Gblame'],
        \ }}

  NeoBundleLazy 'gregsexton/gitv', {
        \ 'autoload': {
        \   'commands': 'Gitv'
        \ }
        \}
endif

