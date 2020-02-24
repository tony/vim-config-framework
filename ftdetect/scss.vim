" https://github.com/cakebaker/scss-syntax.vim#filetype

function! SetupSCSSIndenting()
  if exists(":EditorConfig") == 2
    exe ":EditorConfig"
  else
    setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  endif
  autocmd BufRead,BufNewFile *.scss set filetype=scss.css
endfunction

autocmd BufRead,BufNewFile *.scss call SetupSCSSIndenting() 
