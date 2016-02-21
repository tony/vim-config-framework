function! StartClangFormat()
    if !executable('clang-format') && executable('clang-format37')
      let g:clang_format#command = 'clang-format37'
    endif

    autocmd FileType c,cpp,obcj vnoremap <buffer> <leader>f :call ClangFormat()<cr>

    autocmd FileType c,cpp,objc noremap <silent><leader>f :call ClangFormat<CR>

    let g:clang_format#code_style = 'chromium'
endfunction

autocmd! User vim-clang-format call StartClangFormat()
