if executable('git')

  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive', {
        \ 'on':  ['Gwrite', 'Gcommit', 'Gmove', 'Ggrep', 'Gbrowse', 'Glog',
        \    'Git', 'Gedit', 'Gsplit', 'Gvsplit', 'Gtabedit', 'Gdiff',
        \    'Gstatus', 'Gblame'],
        \ }

  Plug 'gregsexton/gitv', { 'on': 'Gitv' }
endif

