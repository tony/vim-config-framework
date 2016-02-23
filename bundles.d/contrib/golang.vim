if executable('go')
  Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
  Plug 'fatih/vim-go', {
    \ 'for': 'go'
    \ }
  if has('nvim')
    Plug 'zchee/deoplete-go', {
    \ 'for': 'go'
    \ }
  endif
endif

