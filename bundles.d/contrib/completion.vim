if has('nvim')
	Plug 'Shougo/deoplete.nvim' | Plug 'Shougo/context_filetype.vim'
else
Plug 'Shougo/neocomplete.vim', {
  \ 'autoload' : { 'insert' : '1' },
  \ 'disabled' : (!has('lua') || has('nvim'))
  \ }
endif

Plug 'Shougo/echodoc'
