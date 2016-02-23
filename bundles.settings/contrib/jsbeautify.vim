function! StartJsbeautify()
    " JS Beautify options
    " let g:jsbeautify = {'indent_size': 2, 'indent_char': ' '}
    " let g:htmlbeautify = {'indent_size': 2, 'indent_char': ' ', 'max_char': 78, 'brace_style': 'expand', 'unformatted': ['a', 'sub', 'sup', 'b', 'i', 'u', '%', '%=', '?', '?=']}
    " let g:cssbeautify = {'indent_size': 2, 'indent_char': ' '}

    " Set path to js-beautify file
    let s:rootDir = fnamemodify(expand("<sfile>"), ":h")
    let g:jsbeautify_file = fnameescape(s:rootDir."/.vim/vendor/js-beautify/js/beautify.js")
    let g:htmlbeautify_file = fnameescape(s:rootDir."/.vim/vendor/js-beautify/js/beautify-html.js")
    let g:cssbeautify_file = fnameescape(s:rootDir."/.vim/vendor/js-beautify/js/beautify-css.js")
    " expand("$HOME/.vim/ may work")
    " }}}
  autocmd FileType javascript noremap <buffer> <leader>f :call JsBeautify()<CR>
  autocmd FileType html,mustache,jinja,hbs,handlebars,html.handlebars noremap <buffer> <leader>f :call HtmlBeautify()<CR>
autocmd FileType javascript vnoremap <buffer>  <leader>f :call RangeJsBeautify()<cr>
autocmd FileType html,mustache,jinja,hbs,handlebars,html.handlebars vnoremap <buffer> <leader>f :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> <leader>f :call RangeCSSBeautify()<cr>
endfunction

autocmd! User jsbeautify call StartJsbeautify()
