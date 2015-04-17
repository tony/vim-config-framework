if neobundle#tap('vim-go')
  function! neobundle#hooks.on_post_source(bundle)
    au BufNewFile,BufRead *.go set ft=go nu
    au FileType go nnoremap <buffer><leader>r :GoRun<CR>
    au FileType go nnoremap <buffer><leader>g :GoDef<CR>
    au FileType go setlocal tabstop=4
    au FileType go setlocal softtabstop=4
    let g:go_disable_autoinstall = 1
  endfunction
  call neobundle#untap()
endif
