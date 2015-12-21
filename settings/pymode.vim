if neobundle#tap('python-mode')
  function! neobundle#hooks.on_source(bundle)
    let g:pymode_virtualenv=0 " Auto fix vim python paths if virtualenv enabled        
    let g:pymode_folding=1  " Enable python folding 
    let g:pymode_rope = 0
    if neobundle#is_installed('vim-flake8')
      let g:pymode_lint_checkers = []
      autocmd BufWritePost *.py call Flake8()
    else
      let g:pymode_lint_checkers = ['pylint', 'pep8', 'pep257', 'pyflakes', 'mccabe']
    endif
    let g:pymode_lint_ignore = 'C0111,D100,D101,D102,D103'
    let g:pymode_lint_sort = ['E', 'C', 'W', 'R', 'I', 'F', 'D']
    let g:pymode_lint_unmodified = 1

  endfunction

  call neobundle#untap()
endif
