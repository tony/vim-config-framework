if executable('git')

  NeoBundle 'airblade/vim-gitgutter'
  NeoBundle 'tpope/vim-fugitive', {
        \ 'autoload' : {'on_cmd':
        \   ['Gwrite', 'Gcommit', 'Gmove', 'Ggrep', 'Gbrowse', 'Glog',
        \    'Git', 'Gedit', 'Gsplit', 'Gvsplit', 'Gtabedit', 'Gdiff',
        \    'Gstatus', 'Gblame'],
        \ },
        \ 'external_commands' : ['git'],
        \ }

  NeoBundleLazy 'gregsexton/gitv', {
        \ 'autoload': {
        \   'commands': 'Gitv'
        \ }
        \}
endif

