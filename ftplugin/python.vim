" normally: autocmd FileType python

setlocal colorcolumn=88
setlocal foldlevelstart=0
setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4
setlocal textwidth=88
setlocal formatoptions+=croq softtabstop=4 smartindent
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" Highlight everything possible for python
let g:python_highlight_all=1
let g:python_highlight_builtin_funcs=0  " Don't highlight type
let g:python_highlight_builtin_funcs_kwarg=0
