" vim-nodejs-complete
" https://github.com/myhere/vim-nodejs-complete/issues/10
if neobundle#tap('vim-tmux-navigator')
  function! neobundle#hooks.on_post_source(bundle)
    let g:tmux_navigator_no_mappings = 1

    nnoremap <silent> {Left-mapping} :TmuxNavigateLeft<cr>
    nnoremap <silent> {Down-Mapping} :TmuxNavigateDown<cr>
    nnoremap <silent> {Up-Mapping} :TmuxNavigateUp<cr>
    nnoremap <silent> {Right-Mapping} :TmuxNavigateRight<cr>
    nnoremap <silent> {Previous-Mapping} :TmuxNavigatePrevious<c
  endfunction

  call neobundle#untap()
endif
