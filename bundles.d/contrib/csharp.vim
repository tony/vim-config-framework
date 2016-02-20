if executable('xbuild')
  Plug 'OmniSharp/omnisharp-vim', {
      \   'for': 'cs',
      \   'do': 'cd server; xbuild'
      \ }
endif
