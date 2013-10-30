"
" Borrows from https://github.com/terryma/dotfiles/blob/master/.vimrc

"" -------------------
" Look and Feel
" -------------------

" Don't reset twice on reloading - 'compatible' has SO many side effects.
if !exists('s:loaded_my_vimrc')
  source ~/.vim/bundles.vim

  filetype plugin indent on
  syntax enable

  " A wrapper function to restore the cursor position, window position,
  " and last search after running a command.
  function! Preserve(command)
    " Save the last search
    let last_search=@/
    " Save the current cursor position
    let save_cursor = getpos(".")
    " Save the window position
    normal H
    let save_window = getpos(".")
    call setpos('.', save_cursor)

    " Do the business:
    execute a:command

    " Restore the last_search
    let @/=last_search
    " Restore the window position
    call setpos('.', save_window)
    normal zt
    " Restore the cursor position
    call setpos('.', save_cursor)
  endfunction
endif

" Make tabs pretty
"
fu! SeeTab()
  if !exists("g:SeeTabEnabled")
    let g:SeeTabEnabled = 0
  end
  if g:SeeTabEnabled==0
    set listchars=tab:>\ ,trail:-,precedes:<,extends:> " display the following nonprintable characters
    if $LANG =~ ".*\.UTF-8$" || $LANG =~ ".*utf8$" || $LANG =~ ".*utf-8$"
      try
        set listchars=tab:»\ ,trail:·,precedes:…,extends:…
        set list
      catch
      endtry
    endif
    let g:SeeTabEnabled=1
  else
    set listchars&
    let g:SeeTabEnabled=0
  end
endfunc
com! -nargs=0 SeeTab :call SeeTab()

" Map leader and localleader key to comma
let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","



" <Leader>2: Toggle Tagbar
nnoremap <silent> <Leader>2 :TagbarToggle<cr>


nnoremap <silent><leader>3 :call Preserve("normal gg=G")<CR>

" <Leader>7: Toggle between paste mode
nnoremap <silent> <Leader>7 :set paste!<cr>

" <Leader>7: Toggle between paste mode
nnoremap <silent> <Leader>7 :IndentGuidesToggle<cr>

" <Leader>8: Show line numbers
nnoremap <leader>8 :set number!<CR>


" <Leader>tab: Toggles NERDTree
nnoremap <Leader><tab> :NERDTreeToggle<cr>

" <Leader>p: Copy the full path of the current file to the clipboard
nnoremap <silent> <Leader>p :let @+=expand("%:p")<cr>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<cr>

" <Leader>d: Delete the current buffer
nnoremap <Leader><BS> :bdelete<CR>
nnoremap <Leader><Del> :bdelete<CR>



" Q: Closes the window
nnoremap Q :q<cr>


" Up Down Left Right resize splits
nnoremap <up> <c-w>+
nnoremap <down> <c-w>-
nnoremap <left> <c-w><
nnoremap <right> <c-w>>

"===============================================================================
" Visual Mode Ctrl Key Mappings
"===============================================================================

" Ctrl-c: Copy (works with system clipboard due to clipboard setting)
vnoremap <c-c> y`]

" Ctrl-r: Easier search and replace
vnoremap <c-r> "hy:%s/<c-r>h//gc<left><left><left>

" Ctrl-s: Easier substitue
vnoremap <c-s> :s/\%V//g<left><left><left>

" Writes to the unnamed register also writes to the * and + registers. This
" makes it easy to interact with the system clipboard
if has ('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

" Spelling highlights. Use underline in term to prevent cursorline highlights
" from interfering
if !has("gui_running")
  hi clear SpellBad
  hi SpellBad cterm=underline ctermfg=red
  hi clear SpellCap
  hi SpellCap cterm=underline ctermfg=blue
  hi clear SpellLocal
  hi SpellLocal cterm=underline ctermfg=blue
  hi clear SpellRare
  hi SpellRare cterm=underline ctermfg=blue
endif

" Use a low updatetime. This is used by CursorHold
set updatetime=1000

" I like my word boundary to be a little bigger than the default
set iskeyword+=<,>,[,],:,-,`,!
set iskeyword-=_

" Cursor settings. This makes terminal vim sooo much nicer!
" Tmux will only forward escape sequences to the terminal if surrounded by a DCS
" sequence
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


"===============================================================================
"" NERDTree
"===============================================================================

" Close nerdtree on file open
let NERDTreeQuitOnOpen = 1

" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline=1

let NERDTreeShowHidden=1


" Use a single click to fold/unfold directories and a double click to open
" files
let NERDTreeMouseMode=2

" Don't display these kinds of files
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$', '\.git', '\.hg', '\.svn',
      \ '\.ropeproject', '\.bzr', '\.ipynb_checkpoints', '__pycache__',
      \ '\.egg-info$']


"===============================================================================
"" NERDCommenter
"===============================================================================
"
"" Always leave a space between the comment character and the comment
let NERDSpaceDelims=1

" nnoremap <leader>e :call NerdTreeFindPrevBuf()<CR>
" nnoremap <leader>E :NERDTreeClose<CR>

" }}}


" Hey magellen, my dad works at a dealership man! {{{
" nnoremap <leader>t :TagbarOpen fj<cr>
" nnoremap <leader>T :TagbarClose<cr>

" }}}


" File Explorer {{{
" nnoremap <leader>x :Explore<CR>

" }}}


" Buffer Explorer {{{
" nnoremap <leader>b :CtrlPBuffer<CR>

" }}}


" Bexec {{{
" nnoremap <leader>r :Bexec<cr>
" nnoremap <leader>R :BexecCloseOut<cr>

" }}}


" Buffer Traversal {{{
" nnoremap <leader>p :bprevious<CR>
" nnoremap <leader>n :bnext<CR>
" nnoremap <leader>d :bdelete<CR>

" }}}

" Easy <esc> {{{
imap <C-c> <esc>
"imap jk <esc>
"imap hl <esc>
nnoremap <C-c> :if getwinvar(winnr("#"), "&pvw") <Bar> pclose <Bar> endif<CR>

" }}}


" Awesome vim {{{

" based off http://stackoverflow.com/questions/7135985/detecting-split-window-dimensions
command! SplitWindow call s:SplitWindow()
function! s:SplitWindow()
  let l:height=winheight(0) * 2
  let l:width=winwidth(0)
  if (l:height > l:width)
     :split
  else
     :vsplit
  endif
endfunction

" based off http://stackoverflow.com/questions/7135985/detecting-split-window-dimensions
command! ChangeLayout call s:ChangeLayout()
function! s:ChangeLayout()
  let l:height=winheight(0) * 2
  let l:width=winwidth(0)
  if (l:height > l:width)
    <C-w> <C-H>
  else
    <C-w> <C-J>
  endif
endfunction

" Traversal
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-c> :close<CR>

" Moving
" No ctrl-shift sensitivity in vim (or case sensitivity with ascii at all?)
" nnoremap <C-S-h> <C-w>H
" nnoremap <C-S-j> <C-w>J
" nnoremap <C-S-k> <C-w>K
" nnoremap <C-S-l> <C-w>L

" Splitting
nnoremap <C-n> :SplitWindow<CR>
nnoremap <C-Space> :ChangeLayout<CR>

" }}}



" JS Beautify options
" let g:jsbeautify = {'indent_size': 2, 'indent_char': ' '}
" let g:htmlbeautify = {'indent_size': 2, 'indent_char': ' ', 'max_char': 78, 'brace_style': 'expand', 'unformatted': ['a', 'sub', 'sup', 'b', 'i', 'u', '%', '%=', '?', '?=']}
" let g:cssbeautify = {'indent_size': 2, 'indent_char': ' '}

" Set path to js-beautify file
let s:rootDir = fnamemodify(expand("<sfile>"), ":h")
let g:jsbeautify_file = fnameescape(s:rootDir."/.vim/vendor/js-beautify.git/beautify.js")
let g:htmlbeautify_file = fnameescape(s:rootDir."/.vim/vendor/js-beautify.git/beautify-html.js")
let g:cssbeautify_file = fnameescape(s:rootDir."/.vim/vendor/js-beautify.git/beautify-css.js")
  " expand("$HOME/.vim/ may work")
" }}}

"===============================================================================
" Fugitive
"===============================================================================

nnoremap <Leader>gb :Gblame<cr>
nnoremap <Leader>gc :Gcommit<cr>
nnoremap <Leader>gd :Gdiff<cr>
nnoremap <Leader>gp :Git push<cr>
nnoremap <Leader>gr :Gremove<cr>
nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>gw :Gwrite<cr>
" Quickly stage, commit, and push the current file. Useful for editing .vimrc
nnoremap <Leader>gg :Gwrite<cr>:Gcommit -m 'update'<cr>:Git push<cr>



"===============================================================================
" Visual Mode Key Mappings
"===============================================================================

" y: Yank and go to end of selection
xnoremap y y`]

" p: Paste in visual mode should not replace the default register with the
" deleted text
xnoremap p "_dP

" d: Delete into the blackhole register to not clobber the last yank. To 'cut',
" use 'x' instead
xnoremap d "_d

" \: Toggle comment
xmap \ <Leader>c<space>

" Enter: Highlight visual selections
xnoremap <silent> <CR> y:let @/ = @"<cr>:set hlsearch<cr>

" Backspace: Delete selected and go into insert mode
xnoremap <bs> c

" Space: QuickRun
xnoremap <space> :QuickRun<CR>

" <|>: Reselect visual block after indent
xnoremap < <gv
xnoremap > >gv

" .: repeats the last command on every line
xnoremap . :normal.<cr>

" @: repeats macro on every line
xnoremap @ :normal@

" Tab: Indent
xmap <Tab> >

" shift-tab: unindent
xmap <s-tab> <


"===============================================================================
" Vimfiler
"===============================================================================

" TODO Look into Vimfiler more
" Example at: https://github.com/hrsh7th/dotfiles/blob/master/vim/.vimrc
nnoremap <expr><F2> g:my_open_explorer_command()
function! g:my_open_explorer_command()
  return printf(":\<C-u>VimFilerBufferDir -buffer-name=%s -split -auto-cd -toggle -no-quit -winwidth=%s\<CR>",
        \ g:my_vimfiler_explorer_name,
        \ g:my_vimfiler_winwidth)
endfunction

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
" let g:vimfiler_file_icon = ' '
let g:vimfiler_marked_file_icon = '✓'
" let g:vimfiler_readonly_file_icon = ' '
let g:my_vimfiler_explorer_name = 'explorer'
let g:my_vimfiler_winwidth = 30
let g:vimfiler_safe_mode_by_default = 0
" let g:vimfiler_directory_display_top = 1

source ~/.vim/autocmd.vim

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings()
  nmap     <buffer><expr><CR>  vimfiler#smart_cursor_map("\<PLUG>(vimfiler_expand_tree)", "e")
endfunction

"===============================================================================
" VimShell
"===============================================================================

let g:vimshell_prompt = "% "
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
function! s:vimshell_settings()
  call vimshell#altercmd#define('g', 'git')
endfunction

"===============================================================================
" QuickRun
"===============================================================================

let g:quickrun_config = {}
let g:quickrun_config['*'] = {
      \ 'runner/vimproc/updatetime' : 100,
      \ 'outputter' : 'buffer',
      \ 'runner' : 'vimproc',
      \ 'running_mark' : 'ﾊﾞﾝ（∩`･ω･）ﾊﾞﾝﾊﾞﾝﾊﾞﾝﾊﾞﾝﾞﾝ',
      \ 'into' : 1,
      \ 'runmode' : 'async:remote:vimproc'
      \}
" QuickRun triggers markdown preview
let g:quickrun_config.markdown = {
      \ 'runner': 'vimscript',
      \ 'command': ':InstantMarkdownPreview',
      \ 'exec': '%C',
      \ 'outputter': 'null'
      \}

"===============================================================================
" ScratchBuffer
"===============================================================================

autocmd MyAutoCmd User PluginScratchInitializeAfter
\ call s:on_User_plugin_scratch_initialize_after()

function! s:on_User_plugin_scratch_initialize_after()
  map <buffer> <CR>  <Plug>(scratch-evaluate!)
endfunction
let g:scratch_show_command = 'hide buffer'

"===============================================================================
" Quickhl
"===============================================================================

let g:quickhl_colors = [
      \ "gui=bold ctermfg=255 ctermbg=153 guifg=#ffffff guibg=#0a7383",
      \ "gui=bold guibg=#a07040 guifg=#ffffff",
      \ "gui=bold guibg=#4070a0 guifg=#ffffff",
      \ ]


"if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
  "let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
  "let &fillchars = "vert:\u259a,fold:\u00b7"
"else
  "set listchars=tab:>\ ,trail:-,extends:>,precedes:<
"endif

"if v:version >= 600
  "set autoread
  "set foldmethod=marker
  "set printoptions=paper:letter
  "set sidescrolloff=5
  "set mouse=nvi
"endif

"if v:version < 602 || $DISPLAY =~ '^localhost:' || $DISPLAY == ''
  "set clipboard-=exclude:cons\\\|linux
  "set clipboard+=exclude:cons\\\|linux\\\|screen.*
  "if $TERM =~ '^screen'
    "set mouse=
  "endif
"endif

"===============================================================================
" Local Settings
"===============================================================================

try
  source ~/.vimrc.local
catch
endtry

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

" listchar=trail is not as flexible, use the below to highlight trailing
" whitespace. Don't do it for unite windows or readonly files
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup MyAutoCmd
  autocmd BufWinEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
  autocmd InsertEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+\%#\@<!$/ | endif
  autocmd InsertLeave * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
  autocmd BufWinLeave * if &modifiable && &ft!='unite' | call clearmatches() | endif
augroup END

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=10

" Min width of the number column to the left
set numberwidth=1

" Open all folds initially
set foldmethod=indent
set foldlevelstart=99

" No need to show mode due to Powerline
set noshowmode

" Auto complete setting
set completeopt=longest,menuone

set wildmode=list:longest,full
set wildmenu "turn on wild menu
set wildignore=*.o,*.obj,*~,*.pyc "stuff to ignore when tab completing
set wildignore+=*DS_Store*
set wildignore+=__pycache__
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.egg-info
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/Library/**,*/.rbenv/**
set wildignore+=*/.nx/**,*.app

" Allow changing buffer without saving it first
set hidden

" Set backspace config
set backspace=eol,start,indent

" Case insensitive search
set ignorecase
set smartcase

" Set sensible heights for splits
set winheight=50
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
set textwidth=80
set autoindent
set nowrap
set whichwrap+=h,l,<,>,[,]

" no backup-files like bla~ 
set nobackup
set nowritebackup 

" }}}

" Enable filetype detection
"filetype on
"filetype plugin indent on


let g:NERDCustomDelimiters = {
  \ 'sls': { 'left': '#' },
\ }

" highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

if !exists('s:loaded_my_vimrc')
  let s:loaded_my_vimrc = 1
endif

" enables the reading of .vimrc, .exrc and .gvimrc in the current directory.
set exrc

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" Execute 'cmd' while redirecting output.
" Delete all lines that do not match regex 'filter' (if not empty).
" Delete any blank lines.
" Delete '<whitespace><number>:<whitespace>' from start of each line.
" Display result in a scratch buffer.
function! s:Filter_lines(cmd, filter)
  let save_more = &more
  set nomore
  redir => lines
  silent execute a:cmd
  redir END
  let &more = save_more
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  put =lines
  g/^\s*$/d
  %s/^\s*\d\+:\s*//e
  if !empty(a:filter)
    execute 'v/' . a:filter . '/d'
  endif
  0
endfunction
command! -nargs=? Scriptnames call s:Filter_lines('scriptnames', <q-args>

"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
let indent_guides_enable_on_vim_startup = 0
let indent_guides_auto_colors = 0
" 256bit terminal
set t_Co=256

" Tell Vim to use dark background
set background=dark

" Colorscheme
colorscheme molokai

let g:airline_theme = 'molokai'
"source ~/.vim/neocompleterc.vim
let g:pymode_rope = 0


hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey



"{{{2 latex
let g:latex_enabled = 1
let g:latex_viewer = 'mupdf -r 95'
let g:latex_default_mappings = 1

let g:LatexBox_latexmk_async = 1
let g:LatexBox_latexmk_preview_continuously = 1
let g:LatexBox_Folding = 1
let g:LatexBox_viewer = 'mupdf -r 95'
let g:LatexBox_quickfix = 2
let g:LatexBox_split_resize = 1

let g:LatexBox_latexmk_options
    \ = "-pdflatex='pdflatex -synctex=1 \%O \%S'"


"au CursorHoldI * stopinsert  " go back into normal mode in 4 seconds
let g:ycm_filetype_blacklist =
      \ get( g:, 'ycm_filetype_blacklist',
      \   get( g:, 'ycm_filetypes_to_completely_ignore', {
      \     'notes' : 1,
      \     'markdown' : 1,
      \     'text' : 1,
      \     'unite' : 1,
      \ } ) )

let g:riv_auto_format_table = 0

set relativenumber 
set number

let g:airline_powerline_fonts = 1

