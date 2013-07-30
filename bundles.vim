set nocompatible
filetype off

" Setting up Vundle - the vim plugin bundler
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

" Fuzzy Search
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite-help'
NeoBundle 'Shougo/unite-session'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'mileszs/ack.vim'


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
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'jnwhiteh/vim-golang'
" NeoBundle 'vim-scripts/VimClojure'
" NeoBundle 'derekwyatt/vim-scala'
" NeoBundle 'elixir-lang/vim-elixir'
NeoBundle 'evanmiller/nginx-vim-syntax'
NeoBundle 'groenewege/vim-less'
NeoBundle 'juvenn/mustache.vim'
" NeoBundle 'aaronj1335/underscore-templates.vim'
NeoBundle 'saltstack/salt-vim'
NeoBundle "lepture/vim-jinja"
NeoBundle "mklabs/grunt"


" features
" NeoBundle 'ervandew/supertab'

" git
NeoBundle 'tpope/vim-fugitive'

" NeoBundle 'mklabs/vim-backbone'
" NeoBundle 'maksimr/vim-jsbeautify'
" NeoBundle 'einars/js-beautify'

NeoBundle 'majutsushi/tagbar'

NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Shougo/vimfiler'

NeoBundle 'thinca/vim-quickrun'

NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'klen/python-mode'


" NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'terryma/vim-powerline', {'rev':'develop'}


" NeoBundle 'Shougo/neocomplcache'
" NeoBundle 'Shougo/neocomplete'
NeoBundle 'Valloric/YouCompleteMe'

NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Shougo/vimshell'

" NeoBundle 'Shougo/neosnippet'
NeoBundle 'SirVer/ultisnips'

NeoBundle 'jmcantrell/vim-virtualenv'

" NeoBundle 'kien/ctrlp.vim.git'
" NeoBundle 'davidhalter/jedi-vim'
"
NeoBundle 'tpope/vim-capslock'
NeoBundle 'tpope/vim-surround'

" motion
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'goldfeld/vim-seek'

" NeoBundle 'tpope/vim-speeddating'
" NeoBundle 'tpope/vim-sleuth'

" NeoBundle 'godlygeek/tabular'

"NeoBundle 'scrooloose/syntastic'
" let g:syntastic_enable_signs = 1
" let g:syntastic_auto_jump = 1
" let g:syntastic_auto_loc_list = 1

" NeoBundle 'vim-scripts/bufkill.vim'
NeoBundle 'editorconfig/editorconfig-vim'

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
