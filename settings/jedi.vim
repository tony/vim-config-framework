if neobundle#tap('jedi')
  function! neobundle#hooks.on_post_source(bundle)

    let g:jedi#use_tabs_not_buffers = 0
    let g:jedi#use_splits_not_buffers = "left"
    let g:jedi#documentation_command = "<leader>h"
    let g:jedi#usages_command = "<leader>u"

    " https://github.com/davidhalter/jedi-vim/issues/179
    let g:jedi#popup_select_first = 0
    let g:jedi#auto_vim_configuration = 1
  endfunction

  call neobundle#untap()
endif
