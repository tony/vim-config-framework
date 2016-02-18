if neobundle#tap('EditorConfig')
  function! neobundle#hooks.on_source(bundle)
    augroup editorconfig
    autocmd! editorconfig
    autocmd editorconfig BufNewFile,BufReadPost * call EditorConfig()
    autocmd editorconfig BufNewFile,BufRead .editorconfig set filetype=dosini
  endfunction

  call neobundle#untap()
endif
