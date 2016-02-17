if neobundle#tap('echodoc')
  function! neobundle#hooks.on_source(bundle)
    let g:echodoc_enable_at_startup = 1
    set noshowmode
  endfunction

  call neobundle#untap()
endif
