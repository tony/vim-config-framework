function! StartVimtex()
    let g:vimtex_latexmk_options = ''
    let g:vimtex_quickfix_ignored_warnings = [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to',
      \ ]
    let g:vimtex_quickfix_ignore_all_warnings = 1

    let g:vimtex_latexmk_callback = 3
    let g:vimtex_latexmk_continuous = 0
    let g:vimtex_latexmk_enabled = 0
    let g:vimtex_view_enabled = 0
    let g:vimtex_latexmk_file_line_error = 0
endfunction

call PlugOnLoad('vimtex', 'call StartVimtex()')
