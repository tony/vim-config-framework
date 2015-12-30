if neobundle#tap('deoplete.nvim')
  function! neobundle#hooks.on_source(bundle)
    " deoplete.vim
    " credit: https://gist.github.com/zchee/c314e63ae8b6bea50bb4
    let g:deoplete#enable_at_startup = 1
    set completeopt+=noinsert
    let g:deoplete#enable_ignore_case = 'ignorecase'
    let g:deoplete#auto_completion_start_length = 0
    let g:deoplete#sources#go = 'vim-go'
    " https://github.com/Shougo/neocomplete.vim/blob/master/autoload/neocomplete/sources/omni.vim
    let g:deoplete#omni_patterns = {}
    let g:deoplete#omni_patterns.html = '<[^>]*'
    let g:deoplete#omni_patterns.xml  = '<[^>]*'
    let g:deoplete#omni_patterns.md   = '<[^>]*'
    let g:deoplete#omni_patterns.css   = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
    let g:deoplete#omni_patterns.scss   = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
    let g:deoplete#omni_patterns.sass   = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
    let g:deoplete#omni_patterns.javascript = '[^. \t]\.\%(\h\w*\)\?'
    let g:deoplete#omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:deoplete#omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:deoplete#omni_patterns.go = '[^.[:digit:] *\t]\.\w*'
    let g:deoplete#omni_patterns.ruby = ['[^. *\t]\.\w*', '\h\w*::']

    inoremap <expr><C-n> deoplete#mappings#manual_complete()
  endfunction

  call neobundle#untap()
endif
