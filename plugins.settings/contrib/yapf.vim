function! StartYAPF()
    autocmd FileType python noremap <buffer> <leader>f :call yapf#YAPF()<cr>

    autocmd FileType python inoremap <silent><leader>f :call yapf#YAPF()<cr>
endfunction

call PlugOnLoad('yapf', 'call StartYAPF()')
