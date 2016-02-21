function! StartEchoDoc()
    let g:echodoc_enable_at_startup = 1
    set noshowmode
endfunction

autocmd! User echodoc call StartEchoDoc()
