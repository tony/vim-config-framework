set nocompatible
filetype off

filetype plugin indent on

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

filetype plugin indent on
