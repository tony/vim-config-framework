if neobundle#tap('vim-rooter')
  function! neobundle#hooks.on_post_source(bundle)

    " airblade/vim-rooter
    let g:rooter_patterns = ['Rakefile', '.git/', 'gulpfile.js', 'bower.json', 'Gruntfile.js']

  endfunction

  call neobundle#untap()
endif
