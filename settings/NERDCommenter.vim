"===============================================================================
" NERDCommenter
"===============================================================================
if neobundle#tap('nerdcommenter')
  function! neobundle#hooks.on_post_source(bundle)

    "" Always leave a space between the comment character and the comment
    let NERDSpaceDelims=1

    " - Saltstack files (.sls) use # comments
    " - i3 window manager configuration, # comments
    "
    " Useful, for code commenting also see this trick:
    " http://stackoverflow.com/a/2561497
    let g:NERDCustomDelimiters = {
          \ 'sls': { 'left': '#' },
          \ 'i3': { 'left': '#' }
          \ }

  endfunction

  call neobundle#untap()
endif
