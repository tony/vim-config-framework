function StartDeoplete()
    " deoplete.vim
    " credit: https://gist.github.com/zchee/c314e63ae8b6bea50bb4
    let g:deoplete#enable_at_startup = 1
    set completeopt+=noinsert
    set completeopt-=preview
    let g:deoplete#enable_ignore_case = 1
    let g:deoplete#auto_completion_start_length = 0

    if !exists('g:spf13_no_neosnippet_expand')
      imap <C-k> <Plug>(neosnippet_expand_or_jump)
      smap <C-k> <Plug>(neosnippet_expand_or_jump)
      xmap <C-k> <Plug>(neosnippet_expand_target)
      smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

      " For conceal markers.
      if has('conceal')
        set conceallevel=2 concealcursor=niv
      endif
    endif

    let g:deoplete#ignore_sources = {}
    let g:deoplete#ignore_sources._ = ['buffer', 'vim', 'member']
    let g:deoplete#sources#go = 'vim-go'

    inoremap <expr><C-n> deoplete#mappings#manual_complete()
endfunction

call PlugOnLoad('deoplete.nvim', 'call StartDeoplete()')
