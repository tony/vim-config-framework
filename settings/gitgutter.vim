if neobundle#tap('gitgutter')
  function! neobundle#hooks.on_post_source(bundle)
    " lag with gitgutter
    " let g:gitgutter_realtime = 1
    " let g:gitgutter_eager = 0
  endfunction

  call neobundle#untap()
endif
