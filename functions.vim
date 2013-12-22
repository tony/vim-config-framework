" A wrapper function to restore the cursor position, window position,
" and last search after running a command.
function! Preserve(command)
  " Save the last search
  let last_search=@/
  " Save the current cursor position
  let save_cursor = getpos(".")
  " Save the window position
  normal H
  let save_window = getpos(".")
  call setpos('.', save_cursor)

  " Do the business:
  execute a:command

  " Restore the last_search
  let @/=last_search
  " Restore the window position
  call setpos('.', save_window)
  normal zt
  " Restore the cursor position
  call setpos('.', save_cursor)
endfunction


" Make tabs pretty
"
fu! SeeTab()
  if !exists("g:SeeTabEnabled")
    let g:SeeTabEnabled = 0
  end
  if g:SeeTabEnabled==0
    set listchars=tab:>\ ,trail:-,precedes:<,extends:> " display the following nonprintable characters
    if $LANG =~ ".*\.UTF-8$" || $LANG =~ ".*utf8$" || $LANG =~ ".*utf-8$"
      try
        set listchars=tab:»\ ,trail:·,precedes:…,extends:…
        set list
      catch
      endtry
    endif
    let g:SeeTabEnabled=1
  else
    set listchars&
    let g:SeeTabEnabled=0
  end
endfunc


fu! NerdTreeFindPrevBuf()

    if nerdtree#isTreeOpen()
      execute ':NERDTreeClose'
    elseif (!filereadable(bufname('%')) || (bufname('%') == '__Tag_List__') || (bufname('%') == '__Tagbar__'))
      echo "Previous buf not valid or readable file."
      execute ':NERDTree ' . getcwd()
    else
      execute ':NERDTreeFind'
    endif
endfunction
fu! NerdTreeFindPrevBuf2()
  if (bufname('%') == '__Tag_List__') || (bufname('%') == '__Tagbar__')
    wincmd p " previous window
    if !filereadable(bufname('%'))
            wincmd h " mv one window to the left
    endif
    execute ':NERDTreeFind'
  else
    if !filereadable(bufname('%'))
      echo "Previous buf not valid or readable file."
      execute ':NERDTree ' . getcwd()
    else
      execute ':NERDTreeFind'
    endif
  endif
endfunction
