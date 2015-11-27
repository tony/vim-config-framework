if neobundle#tap('echodoc')
  function! neobundle#hooks.before_source(bundle)
    set cmdheight=2
  endfunction

  call neobundle#untap()
endif
