function! StartVimLint()
  let g:vimlint#config = { 'EVL103' : 1  }
  let g:vimlint#config.EVL102 = { 'l:_' : 1 }
  let g:syntastic_vimlint_options = { 'EVL103': 1 }
  " https://github.com/vim-syntastic/syntastic/wiki/VimL:---vimlint#checker-options
  let g:syntastic_vim_vimlint_quiet_messages = { 'regex': '\v\[EVL%(105|205)\]' }
endfunction "}}}

call PlugOnLoad('vim-vimlint', 'call StartVimLint()')
