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
