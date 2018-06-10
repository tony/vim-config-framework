" normally: autocmd FileType python

setlocal colorcolumn=79
highlight ColorColumn ctermbg=8 ctermfg=16 guibg=lightgrey
setlocal foldlevelstart=0
setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4
setlocal textwidth=80
setlocal formatoptions+=croq softtabstop=4 smartindent
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" Check Python files with flake8 and pylint.
let b:ale_linters = ['flake8', 'pylint']
let b:ale_fixers = []

" Highlight everything possible for python
let g:python_highlight_all=1

" turn off jedi (python completion)
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0

function! StartPymode()
    let g:pymode_virtualenv = 1 " Auto fix vim python paths if virtualenv enabled        
    let g:pymode_folding= 1  " Enable python folding
    let g:pymode_rope = 0

    let g:pymode_lint = 0
    if g:pymode_lint != 0
        if exists('flake8')
          let g:pymode_lint_checkers = []
          autocmd BufWritePost *.py call Flake8()
        else
          let g:pymode_lint_checkers = ['pep8', 'pep257', 'pyflakes', 'mccabe']
        endif
        let g:pymode_lint_ignore = 'C0111,D100,D101,D102,D103,E501,W'
        let g:pymode_lint_sort = ['E', 'C', 'W', 'R', 'I', 'F', 'D']
        let g:pymode_lint_unmodified = 1
    endif
    let python_highlight_all=1
    let python_highlight_exceptions=0
    let python_highlight_builtins=0
    let python_slow_sync=1
endfunction

call plugin_loader#PlugOnLoad('python-mode', 'call StartPymode()')
