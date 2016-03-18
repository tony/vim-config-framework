function! StartVimGo()
    au BufNewFile,BufRead *.go set ft=go nu
    au FileType go nmap <leader>r <Plug>(go-run-vertical)
    au FileType go nmap <leader>g <Plug>(go-def-vertical)
    au FileType go nmap <leader>d <Plug>(go-doc-vertical)
    au FileType go nmap <silent> <Leader>f :GoFmt<cr>

    au FileType go setlocal tabstop=4
    au FileType go setlocal softtabstop=4
    au FileType go setlocal shiftwidth=4
    au FileType go setlocal noexpandtab

    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_interfaces = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    let g:go_disable_autoinstall = 1
    let g:go_fmt_command = "goimports"

endfunction

call PlugOnLoad('vim-go', 'call StartVimGo()')
