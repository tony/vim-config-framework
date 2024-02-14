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
" Plug 'gruvbox-material/vim', {'as': 'gruvbox-material'}
Plug 'sainnhe/sonokai'
Plug 'sainnhe/everforest'

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

"lsp
if has('vim9script')
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
endif

" For coc-settings.json jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

" from neoclide coc-css, keyword hint for completions
autocmd FileType scss setl iskeyword+=@-@

" Quickfix keybindings
Plug 'yssl/QFEnter'
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']

Plug 'github/copilot.vim'

Plug 'vim-python/python-syntax'

let g:rainbow_active = 1
Plug 'frazrepo/vim-rainbow'

Plug 'preservim/nerdtree'
let NERDTreeShowHidden=1

Plug 'yasuhiroki/github-actions-yaml.vim'

" if executable('black')
"   autocmd BufWritePost *.py silent !black % --quiet
" endif
"
" if executable('isort')
"   autocmd BufWritePost *.py silent !isort % --quiet
" endif

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

if executable('terraform')
  Plug 'hashivim/vim-terraform'
endif

if executable('mix')
  Plug 'elixir-editors/vim-elixir'
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
