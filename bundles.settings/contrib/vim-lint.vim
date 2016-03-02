function! StartVimLint()
  let g:vimlint#config = { 'EVL103' : 1  }
  let g:vimlint#config.EVL102 = { 'l:_' : 1 }
  let g:syntastic_vimlint_options = { 'EVL103': 1 }

  call neobundle#untap()
endfunction "}}}

autocmd! User vim-vimlint call StartVimLint()
