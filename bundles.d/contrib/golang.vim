if executable('go')
  Plug 'fatih/vim-go', {
	\ 'for': 'go'
	\ }
  if has('nvim')
    Plug 'zchee/deoplete-go'
  endif
endif
