if neobundle#tap('supertab')
  function! neobundle#hooks.on_source(bundle)

    let g:SuperTabLongestHighlight = 0
    let g:SuperTabCrMapping = 0

    let g:SuperTabNoCompleteAfter = [',', '\s']
    let g:SuperTabDefaultCompletionType = "context"
    let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
    let g:SuperTabContextDiscoverDiscovery = ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

  endfunction

  call neobundle#untap()
endif
