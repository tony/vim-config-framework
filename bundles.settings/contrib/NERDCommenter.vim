"===============================================================================
" NERDCommenter
"===============================================================================
function! StartNERDCommenter()

    "" Always leave a space between the comment character and the comment
    let g:NERDSpaceDelims=1

    " - Saltstack files (.sls) use # comments
    " - i3 window manager configuration, # comments
    "
    " Useful, for code commenting also see this trick:
    " http://stackoverflow.com/a/2561497
    let g:NERDCustomDelimiters = {
          \ 'sls': { 'left': '#' },
          \ 'i3': { 'left': '#' }
          \ }

endfunction

autocmd! User nerdcommenter call StartNERDCommenter()
