function! StartMultipleCursors()
    " vim-multiple-cursors
    let g:multi_cursor_quit_key='<C-c>'
    map <C-c> :call multiple_cursors#quit()<CR>
endfunction

autocmd! User vim-multiple-cursors call StartMultipleCursors()
