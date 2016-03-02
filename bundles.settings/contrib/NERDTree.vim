"===============================================================================
" NERDTree
"===============================================================================
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
  "nnoremap <silent> <leader><tab> :call NERDTreeFindPrevBuf()<cr>
  nnoremap <silent> <leader><tab> :NERDTreeToggle<cr>

function! StartNERDTree()

    " <Leader>tab: Toggles NERDTree
    " nnoremap <silent> <leader><tab> :NERDTreeToggle<cr>

    "nnoremap <Leader><tab> :VimFilerExplorer<cr>

    let NERDTreeMapUpdir='-'


    " Close nerdtree on file open
    let NERDTreeQuitOnOpen = 1

    " Highlight the selected entry in the tree
    let NERDTreeHighlightCursorline=1

    let NERDTreeShowHidden=1

    let NERDTreeHijackNetrw=0

    " Use a single click to fold/unfold directories and a double click to open
    " files
    let NERDTreeMouseMode=2

    " let NERDTreeIgnore
    " See ignore.vim

    let g:NERDTreeWinSize = 31

endfunction

call PlugOnLoad('nerdtree', 'call StartNERDTree()')
