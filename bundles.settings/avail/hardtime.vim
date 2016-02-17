if neobundle#tap('hardtime')
  function! neobundle#hooks.on_post_source(bundle)
    "let g:hardtime_default_on = 1
    let g:hardtime_showmsg = 1
  endfunction

  call neobundle#untap()
endif
