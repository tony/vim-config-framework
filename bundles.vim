set nocompatible
filetype off

" Setting up Vundle - the vim plugin bundler
" Credit:  http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
let iCanHazNeoBundle=1
let neobundle_readme=expand('~/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
  echo "Installing neobundle.vim."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
  let iCanHazNeoBundle=0
endif

set rtp+=~/.vim/bundle/neobundle.vim/
call neobundle#rc(expand('~/.vim/bundle/'))


" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
NeoBundle 'Shougo/vimproc', { 'build': {
      \   'windows': 'make -f make_mingw32.mak',
      \   'cygwin': 'make -f make_cygwin.mak',
      \   'mac': 'make -f make_mac.mak',
      \   'unix': 'make -f make_unix.mak',
      \ } }


NeoBundle 'Valloric/YouCompleteMe'
"NeoBundle 'jmcantrell/vim-virtualenv'
"let g:virtualenv_auto_activate = 1

NeoBundleLazy 'klen/python-mode', {
      \ 'autoload' : {
      \   'filetypes' : 'python',
      \ }}

NeoBundleLazy 'PotatoesMaster/i3-vim-syntax', {
      \ 'autoload' : {
      \   'filetypes' : 'i3',
      \ }}

NeoBundleLazy "jceb/vim-orgmode", {
      \ 'autoload' : {
      \   'filetypes' : 'org',
      \ }}

NeoBundle "Raimondi/delimitMate"
NeoBundleLazy 'vim-scripts/closetag.vim'  "  messes up python docstrings


" Fork of NeoBundle "kien/rainbow_parentheses.vim"
NeoBundle "amdt/vim-niji"
" auto rainbow {
nnoremap <leader>r :RainbowParenthesesToggleAll<cr>
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" }

"NeoBundle 'davidhalter/jedi-vim'

" Local complete fork, buggy atm.
" NeoBundle 'ahayman/vim-nodejs-complete'
NeoBundleLazy 'myhere/vim-nodejs-complete', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

" Fuzzy Search
NeoBundle 'Shougo/neomru.vim'

NeoBundle 'Shougo/unite.vim', { 'name' : 'unite.vim'
                            \ , 'depends' : 'vimproc'
                            \ }

NeoBundleLazy 'thinca/vim-unite-history', { 'depends' : 'unite.vim'
                                        \ , 'autoload' : { 'unite_sources' : 'history/command' }
                                        \ }
NeoBundleLazy 'Shougo/unite-help', { 'depends' : 'unite.vim'
                                 \ , 'autoload' : { 'unite_sources' : 'help' }
                                 \ }
NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}}

NeoBundleLazy 'Shougo/unite-session', {'autoload':{'unite_sources':'session', 'commands': ['UniteSessionSave', 'UniteSessionLoad']}}


" NeoBundle 'mileszs/ack.vim'

" NeoBundle 'tpope/vim-vinegar'

NeoBundleLazy 'def-lkb/merlin.git', {'depends': 'def-lkb/vimbufsync.git',
      \ 'build': {
      \   'unix': './configure --bindir ~/bin --without-vimbufsync && make install-binary'
      \   },
      \ 'autoload': {'filetypes': ['ocaml']},
      \ 'rtp': 'vim/merlin'
      \ }


" Colors
" NeoBundleLazy 'jpo/vim-railscasts-theme'
NeoBundleLazy 'altercation/vim-colors-solarized'
NeoBundleLazy 'mbbill/desertEx'
NeoBundle 'tomasr/molokai'
NeoBundle 'chriskempson/base16-vim'
NeoBundleLazy 'nanotech/jellybeans.vim'

" Languages
NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee', 'haml']}}
NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls','ty']}}
NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', {'autoload':{'filetypes':['cpp']}}
NeoBundleLazy 'tpope/vim-haml'
NeoBundleLazy 'tpope/vim-markdown', {'autoload':{'filetypes':['markdown']}}
NeoBundleLazy 'nelstrom/vim-markdown-folding', {'autoload':{'filetypes':['markdown']}}
NeoBundleLazy 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}}


" endwise.vim: wisely add "end" in ruby, endfunction/endif/more in vim script, etc
NeoBundle 'tpope/vim-endwise'

" NeoBundleLazy 'bbommarito/vim-slim'
NeoBundleLazy 'slim-template/vim-slim'
NeoBundleLazy 'wavded/vim-stylus'
NeoBundleLazy 'othree/html5.vim', {
      \ 'autoload' : {
      \   'filetypes' : 'html',
      \ }}


NeoBundleLazy 'jnwhiteh/vim-golang'
" NeoBundleLazy 'vim-scripts/VimClojure'
" NeoBundleLazy 'derekwyatt/vim-scala'
" NeoBundleLazy 'elixir-lang/vim-elixir'
"NeoBundleLazy 'evanmiller/nginx-vim-syntax'
NeoBundleLazy 'evanmiller/nginx-vim-syntax', {'autoload': {'filetypes': 'nginx'}}
NeoBundleLazy 'groenewege/vim-less', {
      \ 'autoload' : {
      \   'filetypes' : 'less',
      \ }}

" causes rst files to load slow...
" NeoBundleLazy 'skammer/vim-css-color', {
" \ 'autoload' : {
" \   'filetypes' : ['css', 'less']
" \ }}

NeoBundleLazy 'hail2u/vim-css3-syntax', {
      \ 'autoload' : {
      \   'filetypes' : ['css', 'less'],
      \ }}

" git
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-git'
NeoBundleLazy 'gregsexton/gitv', { 'depends' : [ 'tpope/vim-fugitive' ]
                               \ , 'autoload' : { 'commands' : 'Gitv' }
                               \ }

NeoBundle 'mustache/vim-mustache-handlebars'
" NeoBundleLazy 'aaronj1335/underscore-templates.vim'
NeoBundle 'saltstack/salt-vim'
NeoBundleLazy "Glench/Vim-Jinja2-Syntax"
NeoBundleLazy "mklabs/grunt", {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

" features
" NeoBundleLazy 'ervandew/supertab'
NeoBundleLazy 'nathanaelkane/vim-indent-guides' " color indentation

if has('conceal')
  NeoBundleLazy 'Yggdroot/indentLine'
endif

NeoBundleLazy 'xolox/vim-lua-ftplugin' , {
      \ 'autoload' : {'filetypes' : 'lua'},
      \ 'depends' : 'xolox/vim-misc',
      \ }

NeoBundleLazy 'elzr/vim-json', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}


NeoBundleLazy 'mklabs/vim-backbone', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}



NeoBundleLazy 'pangloss/vim-javascript', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}


NeoBundleLazy 'maksimr/vim-jsbeautify', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

NeoBundleFetch 'einars/js-beautify' , {
      \   'build' : {
      \       'unix' : 'npm install --update',
      \   },
      \}




NeoBundleFetch 'ramitos/jsctags.git', { 'build': {
    \   'windows': 'npm install',
    \   'cygwin': 'npm install',
    \   'mac': 'npm install',
    \   'unix': 'npm install --update',
    \ },
    \ 'autoload' : {
    \   'filetypes' : 'javascript',
    \ }
\ }
let g:tagbar_type_javascript = {
      \ 'ctagsbin': expand('~/.vim/bundle/jsctags/bin/jsctags')
      \ }

let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'kinds': [ 'r:references', 'h:headers' ],
    \ 'sort': 0,
    \ 'sro': '..',
    \ 'kind2scope': { 'h': 'header' },
    \ 'scope2kind': { 'header': 'h' }
\ }


NeoBundleLazy 'marijnh/tern_for_vim', { 'build': {
      \   'windows': 'npm install',
      \   'cygwin': 'npm install',
      \   'mac': 'npm install',
      \   'unix': 'npm install',
      \ } }


NeoBundleLazy 'majutsushi/tagbar', { 'autoload' : { 'commands' : 'TagbarToggle' } }


NeoBundle 'scrooloose/nerdtree'
" NeoBundleLazy 'Shougo/vimfiler'

" NeoBundleLazy 'thinca/vim-quickrun'

" NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'tomtom/tcomment_vim'

" NeoBundleLazy 'Rykka/riv.vim'
" https://github.com/Rykka/riv.vim/issues/42


"NeoBundleLazy 'Lokaltog/vim-powerline'
NeoBundle 'bling/vim-airline'
" NeoBundleLazy 'terryma/vim-powerline', {'rev':'develop'}


" NeoBundleLazy 'Shougo/neocomplcache'
"NeoBundleLazy 'Shougo/neocomplete'

NeoBundleLazy 'hynek/vim-python-pep8-indent', {
      \ 'filetypes' : 'python',
      \ }

NeoBundle 'tpope/vim-eunuch'

" NeoBundleLazy 'thinca/vim-quickrun'
" NeoBundleLazy 'Shougo/vimshell'

" NeoBundleLazy 'kien/ctrlp.vim.git'
"
NeoBundleLazy 'tpope/vim-capslock'
NeoBundleLazy 'tpope/vim-surround'

" motion
" NeoBundleLazy 'Lokaltog/vim-easymotion'
" NeoBundleLazy 'goldfeld/vim-seek'
" NeoBundle 'gcmt/wildfire.vim'

NeoBundleLazy 'LaTeX-Box-Team/LaTeX-Box', { 'autoload' :
    \   { 'filetypes' : [ 'tex'
                      \ , 'latex'
                      \ ]
    \   }
    \ }

" NeoBundleLazy 'tpope/vim-speeddating'
" NeoBundleLazy 'tpope/vim-sleuth'

" NeoBundleLazy 'godlygeek/tabular'
NeoBundleLazy 'godlygeek/tabular', { 'autoload' : { 'commands' : 'Tabularize' } }

NeoBundle 'scrooloose/syntastic'
let g:syntastic_enable_signs = 1
let g:syntastic_auto_jump = 1
let g:syntastic_auto_loc_list = 1

" NeoBundleLazy 'vim-scripts/bufkill.vim'
" indent yaml
NeoBundleLazy 'avakhov/vim-yaml', {
      \ 'autoload' : {
      \   'filetypes' : 'python',
      \ }}

NeoBundleLazy 'editorconfig/editorconfig-vim'

NeoBundleLazy 'ekalinin/Dockerfile.vim',
  \ {'autoload': {'filetypes': 'Dockerfile'}}

" NeoBundle 'tpope/vim-speeddating'


NeoBundleLazy 'thanthese/Tortoise-Typing', { 'autoload' : {
      \ 'commands' : 'TortoiseTyping'
      \ }}


NeoBundle 'dahu/LearnVim'
NeoBundleLazy 'guns/xterm-color-table.vim', {
      \ 'autoload': {
      \ 'commands': ['XtermColorTable']
      \ }
      \}

NeoBundleLazy 'xsbeats/vim-blade', {
      \ 'autoload' : { 'filetypes' : ['blade'] }}

if iCanHazNeoBundle == 0
  echo "Installing Bundles, please ignore key map error messages"
  echo ""
  :NeoBundleInstall
endif
" Setting up Vundle - the vim plugin bundler end

" Needed for Syntax Highlighting and stuff
filetype plugin indent on
syntax enable

" Installation check.
NeoBundleCheck
