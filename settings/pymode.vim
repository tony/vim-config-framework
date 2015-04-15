if neobundle#tap('youcompleteme')
  function! neobundle#hooks.on_post_source(bundle)
    let g:pymode_virtualenv=1 " Auto fix vim python paths if virtualenv enabled        
    let g:pymode_folding=1  " Enable python folding 
    let g:pymode_rope = 0

  endfunction

  call neobundle#untap()
endif
