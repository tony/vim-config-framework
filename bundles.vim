set nocompatible
filetype off

" Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let iCanHazVundle=0
endif

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" Languages
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-markdown'
Bundle 'nelstrom/vim-markdown-folding'
Bundle 'digitaltoad/vim-jade'
" Bundle 'bbommarito/vim-slim'
Bundle 'slim-template/vim-slim'
Bundle 'wavded/vim-stylus'
Bundle 'othree/html5.vim'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'pangloss/vim-javascript'
Bundle 'jnwhiteh/vim-golang'
Bundle 'vim-scripts/VimClojure'
Bundle 'derekwyatt/vim-scala'
Bundle 'elixir-lang/vim-elixir'
Bundle 'evanmiller/nginx-vim-syntax'
Bundle 'groenewege/vim-less'
Bundle 'juvenn/mustache.vim'
Bundle 'aaronj1335/underscore-templates.vim'
Bundle 'saltstack/salt-vim'
Bundle "lepture/vim-jinja"
Bundle "mklabs/grunt"


" features
Bundle 'Lokaltog/vim-easymotion'
Bundle 'ervandew/supertab'
Bundle 'mklabs/vim-backbone'
Bundle 'tpope/vim-fugitive'
Bundle 'maksimr/vim-jsbeautify'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'klen/python-mode'
Bundle 'einars/js-beautify'
Bundle 'Lokaltog/vim-powerline'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neosnippet'
Bundle 'kien/ctrlp.vim.git'
Bundle 'davidhalter/jedi-vim'

Bundle 'scrooloose/syntastic'
" let g:syntastic_enable_signs = 1
" let g:syntastic_auto_jump = 1
" let g:syntastic_auto_loc_list = 1

Bundle 'vim-scripts/bufkill.vim'
Bundle 'editorconfig/editorconfig-vim'

if iCanHazVundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :BundleInstall
endif
" Setting up Vundle - the vim plugin bundler end

" Needed for Syntax Highlighting and stuff
filetype plugin indent on
syntax enable
