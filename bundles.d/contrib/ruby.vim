if executable('ruby')
  " Plug 'bbommarito/vim-slim'
  Plug 'slim-template/vim-slim'
  Plug 'wavded/vim-stylus'
  if executable('ruby')
    Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
    Plug 'tpope/rbenv-ctags', { 'for': 'ruby' }
    Plug 'tpope/vim-rbenv', { 'for': 'ruby' }

    Plug 'skwp/vim-rspec', { 'for': ['ruby', 'eruby', 'haml'] }
    Plug 'ruby-matchit', { 'for': ['ruby', 'eruby', 'haml'] }
  endif

endif
