function! StartVimAirline()
    let g:airline_detect_iminsert = 1
    " Causes race condition with airline
    " let g:airline_theme = 'base16'
    " Airline theme settings
    let g:airline_powerline_fonts = 1
    "Show buffer list
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_buffers = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
    let g:airline#extensions#tabline#buffer_min_count = 2
endfunction

call PlugOnLoad('vim-airline', 'call StartVimAirline()')
