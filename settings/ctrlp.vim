if neobundle#tap('ctrlp')
  function! neobundle#hooks.on_post_source(bundle)

    let g:ctrlp_reuse_window = 'netrw\|quickfix\|unite'

    " PyMatcher for CtrlP
    if !has('python')
      echo 'In order to use pymatcher plugin, you need +python compiled vim'
    elseif neobundle#is_installed('FelikZ/ctrlp-py-matcher')
      let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
    endif

    let g:ctrlp_dont_split = 'NERD_tree_2'

    let g:ctrlp_fallback = 'find %s -type f'

    if executable("ag")
      let g:ctrlp_fallback = 'ag %s -i --nocolor --nogroup --hidden
            \ --ignore .git
            \ --ignore .svn
            \ --ignore .hg
            \ --ignore .DS_Store
            \ --ignore "**/*.pyc"
            \ -g ""'
      let g:ctrlp_use_caching = 0
    endif
    let g:ctrlp_user_command = {
          \ 'types': {
          \ 1: ['.git', 'cd %s && git ls-files'],
          \ 2: ['.hg', 'hg --cwd %s locate -I .'],
          \ },
          \ 'fallback': ctrlp_fallback
          \ }

    let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
          \ 'mixed', 'funky']

    let g:ctrlp_funky_syntax_highlight = 1
    let g:ctrlp_funky_matchtype = 'path'

    let g:ctrlp_map = '<c-i>'
    let g:ctrlp_cmd = 'CtrlPMixed'

    " nnoremap <silent> <space>o :<C-u>CtrlPBufTag<CR>
    " nnoremap <silent> <space>b :<C-u>CtrlPBuffer<CR>
    " nnoremap <silent> <space>m :<C-u>CtrlPMRU<CR>

    " Map space to the prefix for Unite
    nnoremap [ctrlp] <Nop>
    nmap <space> [ctrlp]

    nnoremap <silent> [ctrlp]<space> :<C-u>CtrlPMixed<CR>
    nnoremap <silent> [ctrlp]o :<C-u>CtrlPFunky<CR>
  endfunction

  call neobundle#untap()
endif
