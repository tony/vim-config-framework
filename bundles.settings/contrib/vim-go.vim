function! StartVimGo()
    au BufNewFile,BufRead *.go set ft=go nu
    au FileType go nnoremap <buffer><leader>r :GoRun<CR>
    au FileType go nnoremap <buffer><leader>g :GoDef<CR>
    au FileType go setlocal tabstop=4
    au FileType go setlocal softtabstop=4

    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_interfaces = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1
    let g:go_disable_autoinstall = 1
    let g:go_fmt_command = "goimports"
    au FileType go nmap <Leader>g <Plug>(go-def-split)
    au FileType go nmap <silent> <Leader>f :GoFmt<cr>

endfunction

call PlugOnLoad('vim-go', 'call StartVimGo()')
