" Test harness for validating Vim configuration changes
" Usage: vim -u test_harness.vim -c "source test_script.vim" -c "qa!"

" Load the main vimrc
source ~/.vim/vimrc

" Test helper functions
function! TestAssert(condition, message)
  if !a:condition
    echohl ErrorMsg
    echom "FAIL: " . a:message
    echohl None
    cquit 1
  else
    echom "PASS: " . a:message
  endif
endfunction

function! TestExists(item, type, message)
  if a:type == 'function'
    call TestAssert(exists('*' . a:item), a:message)
  elseif a:type == 'command'
    call TestAssert(exists(':' . a:item), a:message)
  elseif a:type == 'variable'
    call TestAssert(exists(a:item), a:message)
  endif
endfunction

" Report success
echom "Test harness loaded successfully"