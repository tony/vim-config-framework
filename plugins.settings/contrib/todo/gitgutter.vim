function! StartGitgutter()
    " lag with gitgutter
    let g:gitgutter_realtime = 0
    let g:gitgutter_eager = 0
endfunction

call PlugOnLoad('gitgutter', 'call StartGitgutter()')
