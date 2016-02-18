if neobundle#tap('vim-multiple-cursors')
  function! neobundle#hooks.on_post_source(bundle)
    " vim-multiple-cursors
    let g:multi_cursor_quit_key='<C-c>'
    map <C-c> :call multiple_cursors#quit()<CR>
  endfunction

  call neobundle#untap()
endif
