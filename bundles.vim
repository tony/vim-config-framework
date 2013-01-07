set nocompatible
filetype off

filetype plugin indent on

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

Bundle 'tpope/vim-fugitive'
Bundle 'maksimr/vim-jsbeautify'
Bundle 'juvenn/mustache.vim'
Bundle 'groenewege/vim-less'
Bundle 'saltstack/salt-vim'
Bundle 'tpope/vim-markdown'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdtree'
Bundle 'klen/python-mode'
Bundle 'einars/js-beautify'
Bundle 'Lokaltog/vim-powerline'
Bundle 'aaronj1335/underscore-templates.vim'

if iCanHazVundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    :BundleInstall
endif
" Setting up Vundle - the vim plugin bundler end

filetype plugin indent on
