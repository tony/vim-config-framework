function! StartSyntastic()
    " http://docs.python-guide.org/en/latest/dev/env/
    let g:syntastic_auto_loc_list=1
    let g:syntastic_loc_list_height=5
    let g:syntastic_aggregate_errors = 1

    let g:syntastic_auto_jump = 0
    " Disable html syntastic checker
    " http://stackoverflow.com/a/23105873
    let g:syntastic_html_checkers=['']
    let g:syntastic_rst_checkers=['']
    let g:syntastic_ruby_checkers = ['mri', 'rubylint']
    let g:syntastic_python_checkers = [
                \ 'mccabe', 'flake8', 'pylint', 'pylint', 'pep257', 'mypy'
                \ ]

    if executable('rubocop')
      let g:syntastic_ruby_checkers += ['rubocop']
    endif

    " Disable syntastic for python (managed by python-mode)
    let g:syntastic_mode_map = {
        \ 'mode': 'active',
        \ 'active_filetypes': ['ruby', 'c', 'python'],
        \ 'passive_filetypes': ['go', 'viml', 'cpp'] }

    " Try to improve crippling performance
    " https://github.com/scrooloose/syntastic/issues/175#issuecomment-4034145
    let g:syntastic_enable_signs = 0
    let g:syntastic_enable_balloons = 0
    let g:syntastic_enable_highlighting = 0
    let g:syntastic_echo_current_error = 0
endfunction

call PlugOnLoad('syntastic', 'call StartSyntastic()')
