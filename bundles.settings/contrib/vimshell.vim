"===============================================================================
" VimShell
"===============================================================================
function! StartVimShell()
    let g:vimshell_prompt = "% "
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
    function! s:vimshell_settings()
      call vimshell#altercmd#define('g', 'git')
    endfunction

endfunction

call PlugOnLoad('vimshell', 'call StartVimShell()')
