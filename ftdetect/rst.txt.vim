" Autodetect reStructuredText on .txt files with reST signatures.
" Author: Tony Narlock (tony@git-pull.com)
" License: MIT
"

autocmd BufNewFile,BufRead *.txt :call IsTxtReStructuredText()

function! IsTxtReStructuredText()
  if getline(1) =~ '=\{3,}' || getline(1) =~ '\.\{2} '
    setfiletype rst.text
    setlocal filetype=rst.text
  endif
endfunction
