if neobundle#tap('supertab')
  function! neobundle#hooks.on_post_source(bundle)

    let g:SuperTabLongestHighlight = 0
    let g:SuperTabDefaultCompletionType = '<C-n>'
    let g:SuperTabCrMapping = 0

  endfunction

  call neobundle#untap()
endif
