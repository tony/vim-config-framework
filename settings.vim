" Use a low updatetime. This is used by CursorHold
set updatetime=1000

" I like my word boundary to be a little bigger than the default
" set iskeyword+=<,>,[,],:,-,`,!
" set iskeyword-=_


" Writes to the unnamed register also writes to the * and + registers. This
" makes it easy to interact with the system clipboard
if has ('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif


"===============================================================================
" General Settings
"===============================================================================
syntax on

" This took a while to figure out. Neocomplcache + iTerm + the CursorShape
" fix is causing the completion menu popup to flash the first result. Tested it
" with AutoComplPop and the behavior doesn't exist, so it's isolated to
" Neocomplcache... :( Dug into the source for both and saw that AutoComplPop is
" setting lazyredraw to be on during automatic popup...
set lazyredraw

" Solid line for vsplit separator
" this is breaking 朋友‘s vimrc on osx.
set fcs=vert:│

" Turn on the mouse, since it doesn't play well with tmux anyway. This way I can
" scroll in the terminal
set mouse=a

" Give one virtual space at end of line
set virtualedit=onemore

" Turn on line number
set number

" Always splits to the right and below
set splitright
set splitbelow


" Sets how many lines of history vim has to remember
set history=10000

" Set to auto read when a file is changed from the outside
set autoread

" Set to auto write file
set autowriteall

" Display unprintable chars
set list
" this is breaking 朋友‘s vimrc on osx.
set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:␣
set showbreak=↪


" Minimal number of screen lines to keep above and below the cursor
set scrolloff=10

" Min width of the number column to the left
set numberwidth=1

" Open all folds initially
set foldmethod=indent
set foldlevelstart=99

" No need to show mode due to Powerline
set noshowmode

set wildmode=list:longest,full
set wildmenu "turn on wild menu
" set wildignore
" See ignore.vim

"netrw.vim"{{{
" Change default directory.
set browsedir=current
"}}}


" Allow changing buffer without saving it first
set hidden

" Set backspace config
set backspace=eol,start,indent

" Case insensitive search
set ignorecase
set smartcase

" Set sensible heights for splits
" set winheight=50
" Setting this causes problems with Unite-outline. Don't really need it
" set winminheight=5

" Make search act like search in modern browsers
set incsearch

" Make regex a little easier to type
set magic

" Don't show matching brackets
set noshowmatch

" Show incomplete commands
set showcmd

" Turn off sound
set vb
set t_vb=

" Always show the statusline
set laststatus=2

" Explicitly set encoding to utf-8
set encoding=utf-8

" Column width indicator
set colorcolumn=+1

" Lower the delay of escaping out of other modes
set timeout timeoutlen=1000 ttimeoutlen=0

" Fix meta-keys which generate <Esc>A .. <Esc>z
if !has('gui_running')
  " let c='a'
  " while c <= 'z'
    " exec "set <M-".c.">=\e".c
    " exec "imap \e".c." <M-".c.">"
    " let c = nr2char(1+char2nr(c))
  " endw
  " Map these two on its own to enable Alt-Shift-J and Alt-Shift-K. If I map the
  " whole spectrum of A-Z, it screws up mouse scrolling somehow. Mouse events
  " must be interpreted as some form of escape sequence that interferes.
  " exec 'set <M-J>=J'
  " exec 'set <M-K>=K'
endif

try
  lang en_us
catch
endtry

" Turn backup off
set nobackup
set nowritebackup
set noswapfile

" Tab settings
set expandtab
set shiftwidth=2
set tabstop=8
set softtabstop=2
set smarttab

" Text display settings
set linebreak
" set textwidth=80
set autoindent
set nowrap
set whichwrap+=h,l,<,>,[,]

" no backup-files like bla~ 
set nobackup
set nowritebackup 

" }}}

set relativenumber 
set number

" enables the reading of .vimrc, .exrc and .gvimrc in the current directory.
set exrc

" Use vimgrep.
"set grepprg=internal
"" Use grep.
set grepprg=grep\ -inH


" Startify {{{
" ========

    " A fancy start screen for Vim.

    let g:startify_session_dir = g:SESSION_DIR
    let g:startify_change_to_vcs_root = 1
    let g:startify_list_order = [
        \ ['   Last recently opened files:'],
        \ 'files',
        \ ['   My sessions:'],
        \ 'sessions',
    \ ]
    " let g:startify_change_to_dir = 0
    let g:startify_custom_header = [
        \ '           ______________________________________           ',
        \ '  ________|                                      |_______   ',
        \ '  \       |         VIM ' . v:version . ' - www.vim.org        |      /   ',
        \ '   \      |                                      |     /    ',
        \ '   /      |______________________________________|     \    ',
        \ '  /__________)                                (_________\   ',
        \ '']
" }}}

let g:tagbar_width = 30
let g:tagbar_foldlevel = 1
let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'kinds': [ 'r:references', 'h:headers' ],
    \ 'sort': 0,
    \ 'sro': '..',
    \ 'kind2scope': { 'h': 'header' },
    \ 'scope2kind': { 'header': 'h' }
\ }

"===============================================================================
" UltiSnips
"===============================================================================

" let g:UltiSnipsExpandTrigger="<tab>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"
" " Make UltiSnips works nicely with YCM
" function! g:UltiSnips_Complete()
"     call UltiSnips#ExpandSnippet()
"     if g:ulti_expand_res == 0
"         if pumvisible()
"             return "\<C-n>"
"         else
"             call UltiSnips#JumpForwards()
"             if g:ulti_jump_forwards_res == 0
"                return "\<TAB>"
"             endif
"         endif
"     endif
"     return ""
" endfunction
"
" au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

" https://github.com/Valloric/YouCompleteMe/issues/36#issuecomment-40921899

" delimitMate fix """ python docstrings """
" https://github.com/Raimondi/delimitMate/issues/55, 58, 93
au FileType python let b:delimitMate_nesting_quotes = ['"']
" switch cwd
autocmd BufEnter * silent! lcd %:p:h

" Disable html syntastic checker
" http://stackoverflow.com/a/23105873
let g:syntastic_html_checkers=['']
