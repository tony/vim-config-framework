function! StartVimCodefmt()
     " the glaive#Install() should go after the "call vundle#end()"
    call glaive#Install()
    " " Optional: Enable codefmt's default mappings on the <Leader>= prefix.
    Glaive codefmt plugin[mappings]
     au FileType python,cpp,c,objc,js,node nmap <silent> <Leader>f :FormatCode<cr>
endfunction

call PlugOnLoad('vim-codefmt', 'call StartVimCodefmt()')
