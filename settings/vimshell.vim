"===============================================================================
" VimShell
"===============================================================================
if neobundle#tap('vimshell')
  function! neobundle#hooks.on_post_source(bundle)

    let g:vimshell_prompt = "% "
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
    function! s:vimshell_settings()
      call vimshell#altercmd#define('g', 'git')
    endfunction

  endfunction

  call neobundle#untap()
endif
