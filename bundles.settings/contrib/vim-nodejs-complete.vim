" vim-nodejs-complete
" https://github.com/myhere/vim-nodejs-complete/issues/10
if neobundle#tap('vim-nodejs-complete')
  function! neobundle#hooks.on_post_source(bundle)

    let s:nodejs_complete_config = {
    \ 'js_compl_fn': 'javascriptcomplete#CompleteJS',
    \ 'max_node_compl_len': 0
    \ }
  endfunction

  call neobundle#untap()
endif
