" http://stackoverflow.com/questions/9990219/vim-whats-the-difference-between-let-and-set
" Borrows from https://github.com/terryma/dotfiles/blob/master/.vimrc
" Borrows from https://github.com/klen/.vim

let g:SESSION_DIR   = $HOME.'/.cache/vim/sessions'

" {{{ Plugins
" {{{ Install plugin manager on initial startup
if !isdirectory(expand('$HOME/.vim/pack/minpac'))
  silent execute '!git clone https://github.com/k-takata/minpac.git ~/.vim/pack/minpac/opt/minpac'
  silent execute '!curl -fkLo ~/.vim/autoload/plugpac.vim --create-dirs https://raw.githubusercontent.com/bennyyip/plugpac.vim/master/plugpac.vim'
  autocmd VimEnter * PackInstall
endif
" }}}

call plugpac#begin()

Pack 'k-takata/minpac', {'type': 'opt'}
Pack 'base16-project/base16-vim'                 " Colorschemes set by base16-shell
Pack 'junegunn/fzf'                              " Fuzzy finder integration
Pack 'junegunn/fzf.vim'                          " Additional commands for fzf
Pack 'junegunn/vim-slash'                        " Improved in-buffer search experience
Pack 'machakann/vim-highlightedyank'             " Highlight yanked text
Pack 'machakann/vim-sandwich'                    " Operators and text for manipulating sandwiched text
Pack 'neoclide/coc.nvim', {'branch': 'release'}  " Language Server Protocol client
Pack 'ojroques/vim-oscyank'                      " Copy to system clipboard using the ANSI OSC52 sequence
Pack 'tpope/vim-fugitive'                        " Git shortcuts

call plugpac#end()

" }}}

" {{{ Mappings
" Set the Leader key to Space
nnoremap <Space> <Nop>
let mapleader = "\<Space>"
let maplocalleader = ','

" Quicker split resizing
noremap <Leader><Left>  :vertical resize -3<CR>
noremap <Leader><Right> :vertical resize +3<CR>
noremap <Leader><Up>    :resize +3<CR>
noremap <Leader><Down>  :resize -3<CR>

" Toggle between alternate files
nnoremap <Backspace> <C-^>

" Add relative vertical movements to the jumplist
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'gj'
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'gk'

" Change operations are directed to the black hole register
nnoremap c "_c
nnoremap C "_C

" Joining lines will keep cursor position
nnoremap J mzJ`z

" Yank to the end of line
nnoremap Y y$

" Disable vim's exit message when pressing C-c
nnoremap <C-c> <silent> <C-c>

" +/- -> Increment/decrement numbers in normal or visual mode
nnoremap + <C-a>
nnoremap - <C-x>
xnoremap + g<C-a>gv
xnoremap - g<C-x>gv

" <CTRL-W>h/j/k/l -> Move windows left/up/down/right
nnoremap <C-w>j <C-w>J
nnoremap <C-w>k <C-w>K
nnoremap <C-w>h <C-w>H
nnoremap <C-w>l <C-w>L

" Navigate buffers
nmap <silent> [B :bfirst<CR>
nmap <silent> ]b :bnext<CR>
nmap <silent> [b :bprevious<CR>
nmap <silent> ]B :blast<CR>

" Navigate location list entries
nmap <silent> [L :lfirst<CR>zz
nmap <silent> ]l :lnext<CR>zz
nmap <silent> [l :lprevious<CR>zz
nmap <silent> ]L :llast<CR>zz

" Navigate quickfix list entries
nmap <silent> [Q :cfirst<CR>zz
nmap <silent> ]q :cnext<CR>zz
nmap <silent> [q :cprevious<CR>zz
nmap <silent> ]Q :clast<CR>zz

" Exit insert mode faster
inoremap <Esc> <Esc>l
inoremap kj <Esc>l
inoremap <C-c> <Esc>l

" Fix arrow keys in insert mode
inoremap <silent> <Esc>OA <Up>
inoremap <silent> <Esc>OB <Down>
inoremap <silent> <Esc>OC <Right>
inoremap <silent> <Esc>OD <Left>

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
inoremap <C-^> <C-o><C-^>

" Command line begin/end line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" }}}

" {{{ Autocommands
augroup Vimrc
  autocmd!

  " Save modified buffer during idle after 'updatetime' has elapsed (default 4 sec)
  autocmd CursorHoldI,CursorHold * silent! :update

  " Equalize splits when Vim is resized
  autocmd VimResized * wincmd =

  " Show cursorline in active window only 
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline

  " Jump to the last known cursor position. See $VIMRUNTIME/defaults.vim
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' |
        \   silent execute "normal! g`\"" |
        \ endif

  " Change the working directory to the git project root (uses vim-fugitive)
  autocmd BufLeave * let b:last_cwd = getcwd()
  autocmd BufEnter * 
        \ if exists('b:last_cwd') |
        \   silent execute 'lcd' b:last_cwd |
        \ else |
        \   silent! Glcd |
        \ endif

  " Restore session if a Session.vim file exists
  autocmd VimEnter * nested
        \ if !argc() && empty(v:this_session) && filereadable('Session.vim') && !&modified |
        \   silent execute 'source Session.vim' |
        \ endif

  " Yank to system clipboard under WSL
  let s:clip = '/mnt/c/Windows/System32/clip.exe'
  if executable(s:clip)
    autocmd TextYankPost * 
        \ if v:event.operator ==# 'y' | 
        \   call system(s:clip, @0) | 
        \ endif
  endif

augroup END
" }}}

" {{{ Options
" General
if !&modeline|set modeline|endif " Enable modeline which may be off by default
filetype plugin indent on        " Load plugins according to detected filetype
set background=dark              " Dark background for dark theme support
set backspace=indent,eol,start   " Make backspace work as you would expect
set directory=/tmp//             " Location of the swap file
set display=lastline             " Show as much as possible of the last line
set encoding=utf-8               " Properly display UTF-8 symbols
set foldopen+=jump               " Open a fold if we jump inside it
set hidden                       " Switch between buffers without having to save first
set iskeyword+=-                 " Treat dash separated words as a word text object
set laststatus=2                 " Always show statusline
set mouse=a                      " Enable use of the mouse in all modes
set nobackup                     " Disable backup files
set noshowmode                   " Don't show current mode in command-line
set nrformats=                   " Only recognize decimal numbers for increment/decrement
set pastetoggle=<F2>             " Toggle paste mode on/off
set scrolloff=5                  " Show at least 5 lines above and below the cursor
set shortmess=acFIT              " Customize vim messages
set showcmd                      " Show already typed keys when more are expected
set spelllang=en_us              " Set language for spell checking
set termguicolors                " Use 24-bit colors
set updatetime=300               " Shorter CursorHold delay
scriptencoding utf-8             " Specify character encoding used in this file

" Editing
syntax on                        " Enable syntax highlighting
set autoindent                   " Indent according to previous line
set expandtab                    " Use spaces instead of tabs
set fillchars+=eob:\             " Empty lines below the end of a buffer
set fillchars+=fold:\            " Filling 'foldtext'
set fillchars+=foldopen:\┬       " Mark the beginning of a fold
set fillchars+=foldsep:\│        " Open fold middle character
set fillchars+=vert:\│           " Vertical separators
set listchars=tab:▸\ ,trail:·    " Characters to show in 'list' mode
set matchpairs+=<:>              " Add angle brackets to list of matching pairs
set nojoinspaces                 " Don't add 2 spaces after sentences when joining lines
set nowrap                       " Don't automatically wrap long lines to the window
set number                       " Show line numbers
set shiftround                   " >> indents to next multiple of 'shiftwidth'
set shiftwidth=2                 " >> indents by 2 spaces
set signcolumn=yes               " Always show the signcolumn
set softtabstop=2                " Tab key indents by 2 spaces
set splitbelow splitright        " Open new split panes to right and bottom
set tabstop=2                    " Number of spaces that a <Tab> counts for
set textwidth=0                  " Disable maximum text width

" Searching
set ignorecase                   " Case insensitive search
set incsearch                    " Highlight while searching with / or ?
set path=$PWD/**                 " Find all files under this directory
set smartcase                    " Case sensitive search when using capital letter
set wildcharm=<Tab>              " Allow wildmenu expansion from macros/remaps
set wildignorecase               " Case-insensitive completion of commands, filenames
set wildmenu                     " Enhanced command-line completion
set wildmode=longest:full,full   " Wildmenu completion mode

" Cursor shape
let &t_SI = "\e[6 q"             " INSERT mode - beam cursor
let &t_EI = "\e[2 q"             " NORMAL mode - block cursor
let &t_SR = "\e[4 q"             " REPLACE mode - underline cursor

" Persistent undo
set undodir=/tmp/.vim-undo
if !isdirectory(&undodir)
  call mkdir(&undodir, "p", 0700)
endif
set undofile

" Yank to system clipboard, X11 support
if has('clipboard')
  set clipboard=unnamed
  if has('unnamedplus')
    set clipboard+=unnamedplus
  endif
endif

" True color support
if exists('$TMUX')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Use rg for grep and define a custom grep command
if executable('rg')
  set grepprg=rg\ --vimgrep\ --hidden\ --ignore-case
  set grepformat^=%f:%l:%c:%m
endif

" Grep command opens the quickfix window with results
command! -nargs=+ -complete=file Grep
      \ execute 'silent grep! <args>' | redraw! | cwindow

" vim:fdm=marker
" }}}
