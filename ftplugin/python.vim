" normally: autocmd FileType python
setlocal shiftwidth=4 tabstop=4 softtabstop=4
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class

" Check Python files with flake8 and pylint.
let b:ale_linters = ['flake8', 'pylint']
let b:ale_fixers = []

"" Highlight everything possible for python
let g:python_highlight_all=1
