function! StartEditorConfig()
    augroup editorconfig
    autocmd! editorconfig
    autocmd editorconfig BufNewFile,BufReadPost * call EditorConfig()
    autocmd editorconfig BufNewFile,BufRead .editorconfig set filetype=dosini
endfunction

" autocmd! User EditorConfig call StartEditorConfig()
call StartEditorConfig()
