" http://stackoverflow.com/questions/9990219/vim-whats-the-difference-between-let-and-set
" Borrows from https://github.com/terryma/dotfiles/blob/master/.vimrc
" Borrows from https://github.com/klen/.vim

let g:SESSION_DIR   = $HOME.'/.cache/vim/sessions'

" ALE
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_list_window_size = 5  " Show 5 lines of errors (default: 10)
let g:ale_lint_on_text_changed = 'never'  " Remove lag
let g:ale_lint_on_enter = 0  " no linting on entering file
let g:ale_linters = {'html': []}

" Allow switching away from unsaved buffers
" Or else FZF and :e will fail if moving away from buffer
" https://superuser.com/a/163627
set hidden

" fix backspace
" http://vim.wikia.com/wiki/Backspace_and_delete_problems#Backspace_key_won.27t_move_from_current_line
set backspace=2 " make backspace work like most other programs

" Don't create swap files
set nobackup       "no backup files
set nowritebackup  "only in case you don't want a backup file while editing
set noswapfile     "no swap files

" Glitchy behavior with parents, exception raising 
set noshowmatch
" https://stackoverflow.com/a/47361068
" https://stackoverflow.com/a/47811468
let g:loaded_matchparen=1  " or :NoMatchParen

" Make :e and :vsp show directory relative to buffer
set autochdir

" Fix E353: Nothing in register "
" Writes to the unnamed register also writes to the * and + registers. This
" makes it easy to interact with the system clipboard
if has ('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

call settings#LoadSettings()

call lib#SourceIfExists("~/.vimrc.local")

call lib#SourceIfExists("~/.vim/settings/highlight.vim")


" autocmd
" Set augroup
augroup MyAutoCmd
  autocmd!
augroup END

autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType rst setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4 formatoptions+=nqt textwidth=74
autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType cpp setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNewFile,BufRead *.json setlocal ft=javascript
let javascript_enable_domhtmlcss=1
autocmd FileType markdown setlocal textwidth=80
autocmd FileType css, scss, less setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNewFile,BufRead *.tmpl,*.jinja,*.jinja2 setlocal ft=jinja.html
autocmd BufNewFile,BufRead *.go setlocal ft=go
autocmd FileType gitcommit setlocal spell
autocmd MyAutoCmd FileType json setlocal syntax=javascript


" Keys
"Map leader and localleader key to comma
let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

" Format / indentendation
nnoremap <silent><leader>3 :call "normal gg=G"<CR>

" <Leader>4: Toggle between paste mode
nnoremap <silent> <leader>4 :set paste!<cr>


" thanks terryma: https://github.com/terryma/dotfiles/blob/master/.vimrc
" d: Delete into the blackhole register to not clobber the last yank
nnoremap d "_d
" dd: I use this often to yank a single line, retain its original behavior
nnoremap dd dd

" Show line numbers
" http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
function! NumberRelativeToggle()
  if(&relativenumber == 0 && &number == 0)
    echo "Line numbers not enables, use <leader>7 or :set number / :set relativenumber to enable"
  elseif(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc

nnoremap <silent> <leader>6 :call NumberRelativeToggle()<CR>

function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber   
  endif

  if(&number == 1)
    set nonumber
  else
    set number
  endif

endfunc

nnoremap <silent> <leader>7 :call NumberToggle()!<CR>



" <Leader>p: Copy the full path of the current file to the clipboard
nnoremap <silent> <Leader>p :let @+=expand("%:p")<cr>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<cr>




" Q: Closes the window
nnoremap Q :q<cr>


" Up Down Left Right resize splits
" nnoremap <up> <c-w>+
" nnoremap <down> <c-w>-
" nnoremap <left> <c-w><
" nnoremap <right> <c-w>>

"===============================================================================
" Visual Mode Ctrl Key Mappings
"===============================================================================

" Ctrl-c: Copy (works with system clipboard due to clipboard setting)
" vnoremap <c-c> y`]

" Ctrl-r: Easier search and replace
vnoremap <c-r> "hy:%s/<c-r>h//gc<left><left><left>

" Ctrl-s: Easier substitue
vnoremap <c-s> :s/\%V//g<left><left><left>





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
" nerdcommenter:
" xmap \ <Leader>c<space>
" tcomment:
xmap \ gc<space>

" Enter: Highlight visual selections
xnoremap <silent> <CR> y:let @/ = @"<cr>:set hlsearch<cr>

" Backspace: Delete selected and go into insert mode
xnoremap <bs> c

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

noremap <leader>x :Ex<CR>

" Buffer Traversal {{{
nnoremap <silent> <Leader>d :BD<cr>

" derived from shell commands (Ctrl-b is back a char in command line)
nnoremap <silent> <Leader>p :call PrevBufferOrQuickfix()<CR>
nnoremap <silent> <Leader>n :call NextBufferOrQuickfix()<CR>

nnoremap <silent> <Leader>c :BB<CR>
nnoremap <silent> <Leader><BS> :BB<CR>
nnoremap <silent> <Leader><Del> :BB<CR>

" Traversal
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


nnoremap <C-=> <C-w>=

map ;] :bnext<CR>
map <Leader>] :bnext<CR>
map ;[ :bprev<CR>
map <Leader>[ :bprev<CR>


"" Colors
filetype plugin indent on
syntax enable

" Tell Vim to use dark background
set background=dark

function! ColorSchemeExists(colorscheme)
  try
      exe 'colorscheme' a:colorscheme
      return 1
  catch /^Vim\%((\a\+)\)\=:E185/
      return 0
  endtry
endfunction

if ColorSchemeExists("desert-warm-256")
  colorscheme desert-warm-256
else
  colorscheme desert
endif

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
