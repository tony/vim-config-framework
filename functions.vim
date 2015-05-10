fu! NERDTreeFindPrevBuf()
    if g:NERDTree.IsOpen()
      NERDTreeClose
    elseif (!filereadable(bufname('%')) || (bufname('%') == '__Tag_List__') || (bufname('%') == '__Tagbar__'))
      echo "Previous buf not valid or readable file."
      NERDTree
    else
      NERDTreeFind
    endif
  endfunction


function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
