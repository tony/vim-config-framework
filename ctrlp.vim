
let g:ctrlp_reuse_window = 'netrw\|quickfix\|unite'

" PyMatcher for CtrlP
if !has('python')
  echo 'In order to use pymatcher plugin, you need +python compiled vim'
else
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

" Map space to the prefix for Unite
nnoremap [ctrlp] <Nop>
nmap <space> [ctrlp]

nnoremap <silent> [ctrlp]<space> :<C-u>CtrlPMixed<CR>
nnoremap <silent> [ctrlp]o :<C-u>CtrlPFunky<CR>
