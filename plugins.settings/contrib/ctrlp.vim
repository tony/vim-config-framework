function! StartCtrlP()
  let g:ctrlp_reuse_window = 'netrw\|quickfix\|unite'

  let g:ctrlp_dont_split = 'NERD_tree_2'

  let g:ctrlp_fallback = 'find %s -type f'

  let g:ctrlp_use_caching = 1

  let g:ctrlp_max_files = 0

  let g:ctrlp_working_path_mode = 'ra'

  let g:ctrlp_root_markers = ['.git', '.hg', '.svn', '.bzr', '_darcs']

  if executable("ag")
    let g:ctrlp_fallback = 'ag %s -i --nocolor --nogroup --hidden
          \ --ignore .git
          \ --ignore .svn
          \ --ignore .hg
          \ --ignore .DS_Store
          \ --ignore "**/*.pyc"
          \ -g ""'
  endif
  let g:ctrlp_user_command = {
        \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
        \ 'fallback': g:ctrlp_fallback
        \ }

  let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
        \ 'mixed', 'funky']

  let g:ctrlp_funky_syntax_highlight = 1
  let g:ctrlp_funky_matchtype = 'path'

  let g:ctrlp_map = '<c-i>'
  let g:ctrlp_cmd = 'CtrlPMixed'

  " PyMatcher for CtrlP
  if !has('python') && !has('python3')
    echo 'In order to use pymatcher plugin, you need +python or +python3 compiled vim'
  elseif exists('pymatcher')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  endif


  " nnoremap <silent> <space>o :<C-u>CtrlPBufTag<CR>
  " nnoremap <silent> <space>b :<C-u>CtrlPBuffer<CR>
  " nnoremap <silent> <space>m :<C-u>CtrlPMRU<CR>

  " Map space to the prefix for Unite
  nnoremap [ctrlp] <Nop>
  nmap <space> [ctrlp]

  nnoremap <silent> [ctrlp]<space> :<C-u>CtrlPMixed<CR>
  nnoremap <silent> [ctrlp]o :<C-u>CtrlPFunky<CR>
endfunction

call PlugOnLoad('ctrlp.vim', 'call StartCtrlP()')
