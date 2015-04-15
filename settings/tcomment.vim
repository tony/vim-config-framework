if neobundle#tap('tcomment')
  function! neobundle#hooks.on_post_source(bundle)

    if !exists("g:tcommentGuessFileType_jst")
        let g:tcommentGuessFileType_jst = 'html'   "{{{2
    endif

    if !exists("g:tcommentGuessFileType_i3")
        let g:tcommentGuessFileType_i3 = 'c'   "{{{2
    endif
  endfunction

  call neobundle#untap()
endif
