if neobundle#tap('delimitMate')
  function! neobundle#hooks.on_post_source(bundle)


    " delimitMate fix """ python docstrings """
    " https://github.com/Raimondi/delimitMate/issues/55, 58, 93
    au FileType python let b:delimitMate_nesting_quotes = ['"']
    " switch cwd
    autocmd BufEnter * silent! lcd %:p:h
  endfunction

  call neobundle#untap()
endif
