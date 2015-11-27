if neobundle#tap('echodoc')
  function! neobundle#hooks.on_source(bundle)
    set noshowmode
  endfunction

  call neobundle#untap()
endif
