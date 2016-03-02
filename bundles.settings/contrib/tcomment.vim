function! StartTComment()
    if !exists("g:tcommentGuessFileType_jst")
        let g:tcommentGuessFileType_jst = 'html'   "{{{2
    endif

    if !exists("g:tcommentGuessFileType_i3")
        let g:tcommentGuessFileType_i3 = 'c'   "{{{2
    endif
endfunction

call PlugOnLoad('tcomment', 'call StartTComment()')
