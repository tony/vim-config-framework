" Startify {{{
" ========
function! StartStartify()
    " A fancy start screen for Vim.

    let g:startify_session_dir = g:SESSION_DIR
    let g:startify_change_to_vcs_root = 1
    let g:startify_list_order = [
        \ ['   Last recently opened files:'],
        \ 'files',
        \ ['   My sessions:'],
        \ 'sessions',
    \ ]
    " let g:startify_change_to_dir = 0
    let g:startify_custom_header = [
        \ '           ______________________________________           ',
        \ '  ________|                                      |_______   ',
        \ '  \       |         VIM ' . v:version . ' - www.vim.org        |      /   ',
        \ '   \      |                                      |     /    ',
        \ '   /      |______________________________________|     \    ',
        \ '  /__________)                                (_________\   ',
        \ '']
    " }}}
endfunction

call PlugOnLoad('startify', 'call StartStartify()')
