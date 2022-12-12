if executable('ag')
  Plug 'rking/ag.vim'
endif

Plug 'qpkorr/vim-bufkill'

Plug 'editorconfig/editorconfig-vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'

if executable('pipenv')
  Plug 'cespare/vim-toml'
  au BufNewFile,BufRead Pipfile     setf toml
  au BufNewFile,BufRead Pipfile.lock     setf json
endif

Plug 'GutenYe/json5.vim'

if executable('docker')
  Plug 'ekalinin/Dockerfile.vim'
endif

if executable('git')
  " Plug 'airblade/vim-gitgutter'
  " Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  let g:EditorConfig_exclude_patterns = ['fugitive://.*']
  Plug 'iberianpig/tig-explorer.vim'
endif

if executable('psql')
  Plug 'lifepillar/pgsql.vim'
endif


" helpers for unix: :Move, :Rename, etc
Plug 'tpope/vim-eunuch'

Plug 'dense-analysis/ale'
let g:ale_linters_explicit = 1
let g:ale_set_highlights = 0

Plug 'tomtom/tcomment_vim'
Plug 'mustache/vim-mustache-handlebars', {
      \   'for': ['html', 'mustache', 'hbs']
      \ }

Plug 'tpope/vim-markdown', {'for':['markdown']}
Plug 'airblade/vim-rooter'
Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'cpp'] }
Plug 'chaoren/vim-wordmotion'

Plug 'rainux/vim-desert-warm-256'
Plug 'morhetz/gruvbox'
Plug 'gruvbox-material/vim', {'as': 'gruvbox-material'}

"" CocInstall coc-json coc-html coc-css coc-python coc-tsserver coc-rls coc-vetur
let g:coc_global_extensions = [
  \ 'coc-json',
  "\ 'coc-html',
  "\ 'coc-css',
  \ 'coc-pyright',
  \ 'coc-tsserver',
  \ 'coc-rls',
  "\ 'coc-vetur', 
  \ 'coc-prettier',
  "\ 'coc-pairs',
  "\ 'coc-go',
  \ 'coc-yaml',
  \ 'coc-toml',
  \ 'coc-git',
  \ 'coc-lists',
  "\ 'coc-java'
  \ ]
" coc-clangd as of 2022-05-09

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

function! OnLoadCoc()
  " if ! &rtp =~ 'coc.nvim'
  if !exists('*CocActionAsync') || !exists('*CocAction')
    echo "coc.nvim not initialized, aborting loading"
    return
  endif

  " use <tab> for trigger completion and navigate next complete item
  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Insert <tab> when previous text is space, refresh completion if not.
  inoremap <silent><expr> <TAB>
	\ coc#pum#visible() ? coc#pum#next(1):
	\ CheckBackspace() ? "\<Tab>" :
	\ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
  				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Remap keys for gotos
  nmap <F12> <Plug>(coc-definition)
  nmap <C-F12> <Plug>(coc-type-definition)
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> <leader>g <Plug>(coc-definition)
  nmap <silent> <C-t> <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> <leader>G <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction


  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end
endfunction

autocmd FileType python let b:coc_root_patterns =
        \ ['.git', '.env', 'pyproject.toml', 'Pipfile']
autocmd FileType javascript,typescript,typescript.tsx let b:coc_root_patterns =
        \ ['.git', 'package-lock.json', 'yarn.lock']

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
call plugin_loader#PlugOnLoad('coc.nvim', 'call OnLoadCoc()')


" For coc-settings.json jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

" from neoclide coc-css, keyword hint for completions
autocmd FileType scss setl iskeyword+=@-@

" Quickfix keybindings
Plug 'yssl/QFEnter'
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']

Plug 'vim-python/python-syntax'

let g:rainbow_active = 1
Plug 'frazrepo/vim-rainbow'

if executable('black')
  autocmd BufWritePost *.py silent !black % --quiet
endif

if executable('isort')
  autocmd BufWritePost *.py silent !isort % --quiet
endif

if executable('node')
  " post install (yarn install | npm install) then load plugin only for editing supported files
  " Plug 'prettier/vim-prettier', {
  "   \ 'do': 'yarn install',
  "   \ 'for': ['javascript', 'typescript', 'typescriptreact', 'vue', 'markdown', 'markdown.mdx'] }
  "
  " autocmd BufWritePre *.md,*.mdx,*.ts,*.tsx,*.js,*.jsx execute ':Prettier'
endif

Plug 'vim-autoformat/vim-autoformat'
let g:formatdef_dprint = '"dprint stdin-fmt --file-name ".@%'
let g:formatters_json = ['dprint']
let g:formatters_toml = ['dprint']

if executable('bibtex-tidy')  " Tested with bibtex-tidy at 1.3.1
  autocmd BufWritePost *.bib silent !bibtex-tidy % --quiet --no-backup
endif

Plug 'jparise/vim-graphql'

Plug 'cakebaker/scss-syntax.vim'

if executable('node')
  Plug 'leafgarland/typescript-vim'
  Plug 'HerringtonDarkholme/yats.vim'
  Plug 'posva/vim-vue'
  Plug 'jxnblk/vim-mdx-js'
  Plug 'neoclide/vim-jsx-improve'
  Plug 'jonsmithers/vim-html-template-literals'
endif

if executable('tmux')
  Plug 'wellle/tmux-complete.vim'
endif

if executable('cargo')
  Plug 'rust-lang/rust.vim'
endif


if executable('poetry')
  let g:poetv_auto_activate = 1

  " Plug 'petobens/poet-v'
endif

if has('nvim')
  function! UpdateRemotePlugins(...)
    " Needed to refresh runtime files
    let &rtp=&rtp
    UpdateRemotePlugins
  endfunction

  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
else
  Plug 'gelguy/wilder.nvim'

  " To use Python remote plugin features in Vim, can be skipped
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Credit to https://github.com/wookayin/dotfiles
function! IsPlugInstalled(name) abort
    return has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
endfunction

function! OnLoadWilder()
  " if &rtp =~ 'wilder.nvim'
  if IsPlugInstalled('wilder.nvim')
    " ++once supported in Nvim 0.4+ and Vim 8.1+
    " Also need to switch 
    autocmd CmdlineEnter * ++once call s:wilder_init() | call g:wilder#main#start()

    function! s:wilder_init() abort
      call wilder#setup({'modes': [':', '/', '?']})
      call wilder#set_option('use_python_remote_plugin', 0)
    endfunction
  endif
endfunction

call plugin_loader#PlugOnLoad('wilder.nvim', 'call OnLoadWilder()')
