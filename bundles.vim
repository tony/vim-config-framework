set nocompatible
filetype off

" Setting up Vundle - the vim plugin bundler
" Credit:  http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
let iCanHazVundle=1
let neobundle_readme=expand('~/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
  echo "Installing neobundle.vim."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
  let iCanHazVundle=0
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

NeoBundle "jceb/vim-orgmode"
NeoBundle "Raimondi/delimitMate"
" NeoBundleLazy 'vim-scripts/closetag.vim'  messes up python docstrings


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
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite-help'
NeoBundle 'Shougo/unite-session'
NeoBundle 'thinca/vim-unite-history'
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
NeoBundleLazy 'nanotech/jellybeans.vim'

" Languages
NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee', 'haml']}}
NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls','ty']}}
NeoBundleLazy 'tpope/vim-haml'
NeoBundleLazy 'tpope/vim-markdown', {'autoload':{'filetypes':['markdown']}}
NeoBundleLazy 'nelstrom/vim-markdown-folding', {'autoload':{'filetypes':['markdown']}}
NeoBundleLazy 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}}

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
NeoBundleLazy 'evanmiller/nginx-vim-syntax'

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

NeoBundleLazy 'mustache/vim-mustache-handlebars', {'autoload':{'filetypes':['mustache','hbs']}}
" NeoBundleLazy 'aaronj1335/underscore-templates.vim'
NeoBundleLazy 'saltstack/salt-vim'
" NeoBundleLazy "lepture/vim-jinja"
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


NeoBundleLazy 'marijnh/tern_for_vim', { 'build': {
      \   'windows': 'npm install',
      \   'cygwin': 'npm install',
      \   'mac': 'npm install',
      \   'unix': 'npm install',
      \ } }


NeoBundle 'majutsushi/tagbar'



NeoBundle 'scrooloose/nerdtree'
" NeoBundleLazy 'Shougo/vimfiler'

" NeoBundleLazy 'thinca/vim-quickrun'

NeoBundle 'scrooloose/nerdcommenter'

" NeoBundleLazy 'Rykka/riv.vim'
" https://github.com/Rykka/riv.vim/issues/42


"NeoBundleLazy 'Lokaltog/vim-powerline'
NeoBundle 'bling/vim-airline'
" NeoBundleLazy 'terryma/vim-powerline', {'rev':'develop'}


" NeoBundleLazy 'Shougo/neocomplcache'
"NeoBundleLazy 'Shougo/neocomplete'

NeoBundleLazy 'hynek/vim-python-pep8-indent'



" NeoBundleLazy 'thinca/vim-quickrun'
" NeoBundleLazy 'Shougo/vimshell'

" NeoBundleLazy 'Shougo/neosnippet'
" NeoBundleLazy 'SirVer/ultisnips'

NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'

" NeoBundleLazy 'kien/ctrlp.vim.git'
"
NeoBundleLazy 'tpope/vim-capslock'
NeoBundleLazy 'tpope/vim-surround'

" motion
" NeoBundleLazy 'Lokaltog/vim-easymotion'
" NeoBundleLazy 'goldfeld/vim-seek'
" NeoBundle 'gcmt/wildfire.vim'

NeoBundleLazy 'LaTeX-Box-Team/LaTeX-Box'

" NeoBundleLazy 'tpope/vim-speeddating'
" NeoBundleLazy 'tpope/vim-sleuth'

" NeoBundleLazy 'godlygeek/tabular'

NeoBundleLazy 'scrooloose/syntastic'
let g:syntastic_enable_signs = 1
let g:syntastic_auto_jump = 1
let g:syntastic_auto_loc_list = 1

" NeoBundleLazy 'vim-scripts/bufkill.vim'
NeoBundleLazy 'avakhov/vim-yaml'
NeoBundleLazy 'editorconfig/editorconfig-vim'

NeoBundleLazy "ekalinin/Dockerfile.vim"

" NeoBundleLazy 'flazz/vim-colorschemes'

" NeoBundle 'tpope/vim-speeddating'

NeoBundleLazy 'thanthese/Tortoise-Typing', { 'autoload' : {
      \ 'commands' : 'TortoiseTyping'
      \ }}

if iCanHazVundle == 0
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
