if neobundle#tap('vim-clang-format')
  function! neobundle#hooks.on_post_source(bundle)
    if !executable('clang-format') && executable('clang-format37')
      let g:clang_format#command = 'clang-format37'
    endif
  endfunction

  call neobundle#untap()
endif
