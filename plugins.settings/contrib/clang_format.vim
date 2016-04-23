function! StartClangFormat()
    if !executable('clang-format') && executable('clang-format37')
      let g:clang_format#command = 'clang-format37'
    endif

    autocmd FileType c,cpp,objc vnoremap <buffer> <leader>f :call ClangFormat()<cr>

    autocmd FileType c,cpp,objc noremap <silent><leader>f :call ClangFormat()<cr>

    let g:clang_format#code_style = 'chromium'
endfunction

call PlugOnLoad('vim-clang-format', 'call StartClangFormat()')
