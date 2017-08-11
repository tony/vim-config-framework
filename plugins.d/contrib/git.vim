if executable('git')
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'
  let g:EditorConfig_exclude_patterns = ['fugitive://.*']

  Plug 'gregsexton/gitv', { 'on': 'Gitv' }
endif

