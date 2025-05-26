" vim-plug auto-installation is handled by plugin_loader.vim

"------------------------------------------------------------------------------
" Helper Function: Conditionally load a plugin if an executable is found
"------------------------------------------------------------------------------
function! PlugIfCommand(cmd, plugin_spec, ...) abort
  if executable(a:cmd)
    if !empty(a:000)
      Plug a:plugin_spec, a:000[0]
    else
      Plug a:plugin_spec
    endif
  endif
endfunction

"------------------------------------------------------------------------------
" Begin Plugin Section
"------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

" Unconditional Plugins
Plug 'qpkorr/vim-bufkill'
Plug 'editorconfig/editorconfig-vim'

" fzf + fzf.vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all --no-update-rc' }
Plug 'junegunn/fzf.vim'

" JSON5
Plug 'GutenYe/json5.vim'

" Unix helpers (e.g., :Move, :Rename, etc.)
Plug 'tpope/vim-eunuch'

" ALE linting
Plug 'dense-analysis/ale'
" Consolidated ALE settings
let g:ale_linters_explicit = 1
let g:ale_set_highlights = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_list_window_size = 5
let g:ale_lint_on_enter = 0

" Enable echo/hover functionality for linting messages
let g:ale_echo_cursor = 1
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_cursor_detail = 0
let g:ale_hover_cursor = 1
let g:ale_set_balloons = has('balloon_eval') && has('gui_running')

" Per-language linters
let g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint', 'tsserver', 'typecheck'],
      \ }

" Per-language fixers  
let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'typescript': ['trim_whitespace', 'prettier'],
      \ }

" Comments
Plug 'tomtom/tcomment_vim'

" Mustache / Handlebars
Plug 'mustache/vim-mustache-handlebars', {
      \ 'for': ['html', 'mustache', 'hbs']
      \ }

" Markdown
Plug 'tpope/vim-markdown', {'for': ['markdown']}

" Root dir detection
Plug 'airblade/vim-rooter'

" Extra syntax for C/C++
Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'cpp'] }

" Word motion
Plug 'chaoren/vim-wordmotion'

" Colorschemes
Plug 'rainux/vim-desert-warm-256'
Plug 'morhetz/gruvbox'
" Plug 'gruvbox-material/vim', {'as': 'gruvbox-material'}
Plug 'sainnhe/sonokai'
Plug 'sainnhe/everforest'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

" NERDTree
Plug 'preservim/nerdtree'
let NERDTreeShowHidden=1

" GraphQL
Plug 'jparise/vim-graphql'

" SCSS
Plug 'cakebaker/scss-syntax.vim'

" JSON for GitHub Actions
Plug 'yasuhiroki/github-actions-yaml.vim'

" Autoformat
Plug 'vim-autoformat/vim-autoformat'
let g:formatdef_dprint = '"dprint stdin-fmt --file-name ".@%'
let g:formatters_json = ['dprint']
let g:formatters_toml = ['dprint']

" Copilot
Plug 'github/copilot.vim'
let g:copilot_filetypes = {
    \ 'markdown': v:false,
    \ 'rst': v:false,
    \ 'zsh': v:false,
    \ 'bash': v:false,
    \ 'fish': v:false,
    \ 'json': v:false,
    \ }

" Python syntax improvements
Plug 'vim-python/python-syntax'

" Rainbow parentheses
Plug 'frazrepo/vim-rainbow'
let g:rainbow_active = 1

" Quickfix enhancements
Plug 'yssl/QFEnter'
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']

" Coc.nvim (the main LSP plugin)
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'yarn install --frozen-lockfile'}

" Wilder for better command-line completion
if has('nvim')
  Plug 'gelguy/wilder.nvim', { 'do': { -> UpdateRemotePlugins() } }
  " Neovim-specific colorscheme
  Plug 'folke/tokyonight.nvim'
  " Nvim requires remote plugins update
  function! UpdateRemotePlugins()
    let &rtp=&rtp  " refresh runtime
    UpdateRemotePlugins
  endfunction
else
  Plug 'gelguy/wilder.nvim'
  " For Python remote features in Vim 8:
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" Conditional Plugins Based on Executables
" Format: 'command': ['plugin1', 'plugin2', ...]
let s:conditional_plugins = {
  \ 'ag':        ['rking/ag.vim'],
  \ 'pipenv':    ['cespare/vim-toml'],
  \ 'docker':    ['ekalinin/Dockerfile.vim'],
  \ 'git':       ['tpope/vim-fugitive', 'iberianpig/tig-explorer.vim'],
  \ 'psql':      ['lifepillar/pgsql.vim'],
  \ 'node':      ['leafgarland/typescript-vim', 'HerringtonDarkholme/yats.vim',
  \               'posva/vim-vue', 'jxnblk/vim-mdx-js',
  \               'neoclide/vim-jsx-improve', 'jonsmithers/vim-html-template-literals'],
  \ 'tmux':      ['wellle/tmux-complete.vim'],
  \ 'cargo':     ['rust-lang/rust.vim'],
  \ 'terraform': ['hashivim/vim-terraform'],
  \ 'mix':       ['elixir-editors/vim-elixir'],
  \ }

" Load conditional plugins
for [cmd, plugins] in items(s:conditional_plugins)
  for plugin in plugins
    call PlugIfCommand(cmd, plugin)
  endfor
endfor

" End of plugin block
call plug#end()

"------------------------------------------------------------------------------
" BufRead / BufNewFile Autocommands for certain filetypes
"------------------------------------------------------------------------------
if executable('pipenv')
  augroup MyPipenvFiles
    autocmd!
    autocmd BufNewFile,BufRead Pipfile       setf toml
    autocmd BufNewFile,BufRead Pipfile.lock  setf json
  augroup END
endif

" Quick JSONC style for coc-settings or some other JSON with comments
autocmd FileType json syntax match Comment +\/\/.\+$+
autocmd FileType scss setlocal iskeyword+=@-@

" Additional root patterns for certain filetypes
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'pyproject.toml', 'Pipfile']
autocmd FileType javascript,typescript,typescript.tsx let b:coc_root_patterns = ['.git', 'package-lock.json', 'yarn.lock']

" If we have bibtex-tidy installed, auto-clean .bib files
if executable('bibtex-tidy')
  autocmd BufWritePost *.bib silent! !bibtex-tidy % --quiet --no-backup
endif

"------------------------------------------------------------------------------
" General Settings for CoC, signcolumn, etc.
"------------------------------------------------------------------------------

" CoC global extensions
let g:coc_global_extensions = [
  \ 'coc-json',
  \ 'coc-pyright',
  \ 'coc-tsserver',
  \ 'coc-rust-analyzer',
  \ 'coc-prettier',
  \ 'coc-yaml',
  \ 'coc-toml',
  \ 'coc-git',
  \ 'coc-lists',
  \ ]

" Faster updates (for lint / diagnostics)
set updatetime=300

" Don't show messages in completion popups
set shortmess+=c

" Show signcolumn so text doesn't shift
if has('nvim-0.5.0') || has('patch-8.1.1564')
  set signcolumn=number
else
  set signcolumn=yes
endif

"------------------------------------------------------------------------------
" OnLoadCoc Function
"------------------------------------------------------------------------------
function! OnLoadCoc() abort
  " If coc.nvim isn't properly loaded, bail out
  if !exists('*CocActionAsync') || !exists('*CocAction')
    echo "coc.nvim not initialized, skipping CoC config"
    return
  endif

  " <Tab> to navigate completions (simplified)
  inoremap <silent><expr> <TAB>
	\ coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
  inoremap <silent><expr> <S-TAB>
        \ coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
  inoremap <silent><expr> <CR> 
        \ coc#pum#visible() ? coc#pum#confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Goto / references
  nmap <silent> gd   <Plug>(coc-definition)
  nmap <silent> gy   <Plug>(coc-type-definition)
  nmap <silent> gi   <Plug>(coc-implementation)
  nmap <silent> gr   <Plug>(coc-references)
  
  " Additional vim-style mappings
  nmap <silent> <C-t> <Plug>(coc-definition)
  nmap <silent> <leader>g <Plug>(coc-definition)
  nmap <silent> <leader>G <Plug>(coc-type-definition)
  
  " VS Code / Visual Studio compatible mappings
  nmap <silent> <F12>    <Plug>(coc-definition)
  nmap <silent> <C-F12>  <Plug>(coc-implementation)
  nmap <silent> <S-F12>  <Plug>(coc-references)
  " Note: Alt+F12 would be peek definition, but Vim doesn't have peek mode
  " Note: Ctrl+Shift+F12 for type definition conflicts with terminal behavior
  
  " Navigation history (VS Code compatible)
  " Note: Alt+Left/Right often conflicts with terminal, using Ctrl+O/I instead
  " Vim already has Ctrl+O (back) and Ctrl+I (forward) for jump list

  " Highlight references on CursorHold
  autocmd CursorHold * silent! call CocActionAsync('highlight')

  " Show documentation with K
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation() abort
    if index(['vim','help'], &filetype) >= 0
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  augroup MyCoCFormat
    autocmd!
    autocmd FileType typescript,json setlocal formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup END
endfunction

" Trigger the above function once CoC is loaded
autocmd VimEnter * call OnLoadCoc()

"------------------------------------------------------------------------------
" Wilder (better command-line UI)
"------------------------------------------------------------------------------
function! OnLoadWilder() abort
  autocmd CmdlineEnter * ++once call s:wilder_init() | call g:wilder#main#start()
  function! s:wilder_init() abort
    call wilder#setup({'modes': [':', '/', '?']})
    call wilder#set_option('use_python_remote_plugin', 0)
  endfunction
endfunction

autocmd VimEnter * call OnLoadWilder()

"------------------------------------------------------------------------------
" Optional: source any additional plugin definitions for Neovim
"------------------------------------------------------------------------------
" Neovim-specific plugins are now included above
