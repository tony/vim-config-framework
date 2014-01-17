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

NeoBundle 'klen/python-mode'

"NeoBundle 'davidhalter/jedi-vim'


" Fuzzy Search
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite-help'
NeoBundle 'Shougo/unite-session'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'mileszs/ack.vim'

" NeoBundle 'tpope/vim-vinegar'

NeoBundleLazy 'def-lkb/merlin.git', {'depends': 'def-lkb/vimbufsync.git',
    \ 'build': {
    \   'unix': './configure --bindir ~/bin --without-vimbufsync && make install-binary'
    \   },
    \ 'autoload': {'filetypes': ['ocaml']},
    \ 'rtp': 'vim/merlin'
    \ }


" Colors
" NeoBundle 'jpo/vim-railscasts-theme'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'mbbill/desertEx'
NeoBundle 'tomasr/molokai'
NeoBundle 'nanotech/jellybeans.vim'

" Languages
" NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'tpope/vim-haml'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'nelstrom/vim-markdown-folding'
NeoBundle 'digitaltoad/vim-jade'
" NeoBundle 'bbommarito/vim-slim'
NeoBundle 'slim-template/vim-slim'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'othree/html5.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'jnwhiteh/vim-golang'
" NeoBundle 'vim-scripts/VimClojure'
" NeoBundle 'derekwyatt/vim-scala'
" NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'evanmiller/nginx-vim-syntax'

NeoBundle 'groenewege/vim-less'
"NeoBundle 'skammer/vim-css-color'  " causing rst files to load slow as ass
NeoBundle 'hail2u/vim-css3-syntax'

NeoBundle 'juvenn/mustache.vim'
" NeoBundle 'aaronj1335/underscore-templates.vim'
NeoBundle 'saltstack/salt-vim'
" NeoBundle "lepture/vim-jinja"
NeoBundle "Glench/Vim-Jinja2-Syntax"
NeoBundle "mklabs/grunt"


" features
" NeoBundle 'ervandew/supertab'
NeoBundle 'nathanaelkane/vim-indent-guides' " color indentation
if has('conceal')
  NeoBundle 'Yggdroot/indentLine'
endif

NeoBundleLazy 'xolox/vim-lua-ftplugin', {
      \ 'autoload' : {
      \   'filetypes' : 'lua',
      \ }}
NeoBundleLazy 'elzr/vim-json', {
      \ 'autoload' : {
      \   'filetypes' : 'json',
      \ }}

" git
" NeoBundle 'tpope/vim-fugitive'

" NeoBundle 'mklabs/vim-backbone'
NeoBundle 'maksimr/vim-jsbeautify'
" NeoBundle 'einars/js-beautify'

NeoBundle 'majutsushi/tagbar'

NeoBundle 'scrooloose/nerdtree'
" NeoBundle 'Shougo/vimfiler'

" NeoBundle 'thinca/vim-quickrun'

NeoBundle 'scrooloose/nerdcommenter'

" NeoBundle 'Rykka/riv.vim'
" https://github.com/Rykka/riv.vim/issues/42


"NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'bling/vim-airline'
" NeoBundle 'terryma/vim-powerline', {'rev':'develop'}


" NeoBundle 'Shougo/neocomplcache'
"NeoBundle 'Shougo/neocomplete'

NeoBundle 'hynek/vim-python-pep8-indent'


NeoBundle 'marijnh/tern_for_vim', { 'build': {
      \   'windows': 'npm install',
      \   'cygwin': 'npm install',
      \   'mac': 'npm install',
      \   'unix': 'npm install',
      \ } }



" NeoBundle 'thinca/vim-quickrun'
" NeoBundle 'Shougo/vimshell'

" NeoBundle 'Shougo/neosnippet'
" NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'
NeoBundle 'SirVer/ultisnips'

" NeoBundle 'kien/ctrlp.vim.git'
"
NeoBundle 'tpope/vim-capslock'
NeoBundle 'tpope/vim-surround'

" motion
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'goldfeld/vim-seek'

NeoBundle 'LaTeX-Box-Team/LaTeX-Box'

" NeoBundle 'tpope/vim-speeddating'
" NeoBundle 'tpope/vim-sleuth'

" NeoBundle 'godlygeek/tabular'

NeoBundle 'scrooloose/syntastic'
let g:syntastic_enable_signs = 1
let g:syntastic_auto_jump = 1
let g:syntastic_auto_loc_list = 1

" NeoBundle 'vim-scripts/bufkill.vim'
NeoBundle 'avakhov/vim-yaml'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'vim-scripts/closetag.vim'
NeoBundle 'xolox/vim-misc'

NeoBundle "ekalinin/Dockerfile.vim"

NeoBundle 'flazz/vim-colorschemes'

NeoBundle 'mhinz/vim-startify'

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
