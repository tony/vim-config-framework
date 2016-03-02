" vim-nodejs-complete
" https://github.com/myhere/vim-nodejs-complete/issues/10
function! StartNodejsComplete()
    let s:nodejs_complete_config = {
    \ 'js_compl_fn': 'javascriptcomplete#CompleteJS',
    \ 'max_node_compl_len': 0
    \ }
endfunction

call PlugOnLoad('vim-nodejs-complete', 'call StartNodejsComplete()')
