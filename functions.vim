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


fu! NERDTreeFindPrevBuf()

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


" Execute 'cmd' while redirecting output.
" Delete all lines that do not match regex 'filter' (if not empty).
" Delete any blank lines.
" Delete '<whitespace><number>:<whitespace>' from start of each line.
" Display result in a scratch buffer.
function! s:Filter_lines(cmd, filter)
  let save_more = &more
  set nomore
  redir => lines
  silent execute a:cmd
  redir END
  let &more = save_more
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  put =lines
  g/^\s*$/d
  %s/^\s*\d\+:\s*//e
  if !empty(a:filter)
    execute 'v/' . a:filter . '/d'
  endif
  0
endfunction
command! -nargs=? Scriptnames call s:Filter_lines('scriptnames', <q-args>


" Awesome vim {{{

" based off http://stackoverflow.com/questions/7135985/detecting-split-window-dimensions
" command! SplitWindow call s:SplitWindow()
" function! s:SplitWindow()
" let l:height=winheight(0) * 2
" let l:width=winwidth(0)
" if (l:height > l:width)
" :split
" else
" :vsplit
" endif
" endfunction

" " based off http://stackoverflow.com/questions/7135985/detecting-split-window-dimensions
" command! ChangeLayout call s:ChangeLayout()
" function! s:ChangeLayout()
" let l:height=winheight(0) * 2
" let l:width=winwidth(0)
" if (l:height > l:width)
" <C-w> <C-H>
" else
" <C-w> <C-J>
" endif
" endfunction

" Find and replace visual
" Source: http://stackoverflow.com/a/6171215
" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " let string = substitute(
  "   \ escape(string, '/\.*$^~[]'),
  "   \ '\_s\+',
  "   \ '\\_s\\+',
  "   \ 'g')

  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')

  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction
