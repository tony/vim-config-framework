if neobundle#is_installed('tony/vim-multiple-cursors') || neobundle#is_installed('terryma/vim-multiple-cursors')
  " vim-multiple-cursors
  let g:multi_cursor_quit_key='<C-c>'
  map <C-c> :call multiple_cursors#quit()<CR>
endif
