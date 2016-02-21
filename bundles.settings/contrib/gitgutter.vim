function! StartGitgutter()
    " lag with gitgutter
    " let g:gitgutter_realtime = 1
    " let g:gitgutter_eager = 0
endfunction

autocmd! User gitgutter call StartGitgutter()
