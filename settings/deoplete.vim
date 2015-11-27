if neobundle#tap('deoplete.vim')
  function! neobundle#hooks.before_source(bundle)
    let g:deoplete#enable_at_startup = 1
  endfunction

  call neobundle#untap()
endif
