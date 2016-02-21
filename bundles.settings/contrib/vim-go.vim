function! StartVimGo()
    au BufNewFile,BufRead *.go set ft=go nu
    au FileType go nnoremap <buffer><leader>r :GoRun<CR>
    au FileType go nnoremap <buffer><leader>g :GoDef<CR>
    au FileType go setlocal tabstop=4
    au FileType go setlocal softtabstop=4
    let g:go_disable_autoinstall = 1
endfunction

autocmd! User vim-go call StartVimGo()
