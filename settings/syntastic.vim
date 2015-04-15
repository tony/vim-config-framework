if neobundle#tap('syntastic')
  function! neobundle#hooks.on_post_source(bundle)

    " http://docs.python-guide.org/en/latest/dev/env/
    let g:syntastic_auto_loc_list=1
    let g:syntastic_loc_list_height=5

    let g:syntastic_enable_signs = 2
    let g:syntastic_auto_jump = 1
    " Disable html syntastic checker
    " http://stackoverflow.com/a/23105873
    let g:syntastic_html_checkers=['']
    let g:syntastic_rst_checkers=['']

    " Disable syntastic for python (managed by python-mode)
    let g:syntastic_mode_map = {
        \ 'mode': 'active',
        \ 'active_filetypes': [],
        \ 'passive_filetypes': ['python', 'go'] }

    " Try to improve crippling performance
    " https://github.com/scrooloose/syntastic/issues/175#issuecomment-4034145
    let g:syntastic_enable_signs = 0
    let g:syntastic_enable_balloons = 0
    let g:syntastic_enable_highlighting = 0
    let g:syntastic_enable_highlighting = 0
    let g:syntastic_echo_current_error = 0
  endfunction

  call neobundle#untap()
endif
