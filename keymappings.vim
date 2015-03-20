"Map leader and localleader key to comma
let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

" <Leader>2: Toggle Tagbar
nnoremap <silent> <Leader>2 :TagbarToggle<cr>

" Format / indentendation
nnoremap <silent><leader>3 :call Preserve("normal gg=G")<CR>

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


" <Leader>tab: Toggles NERDTree
" nnoremap <silent> <leader><tab> :NERDTreeToggle<cr>
nnoremap <silent> <leader><tab> :call NerdTreeFindPrevBuf()<cr>
"nnoremap <Leader><tab> :VimFilerExplorer<cr>

let NERDTreeMapUpdir='-'
" <Leader>p: Copy the full path of the current file to the clipboard
nnoremap <silent> <Leader>p :let @+=expand("%:p")<cr>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<cr>




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
" vnoremap <c-c> y`]

" Ctrl-r: Easier search and replace
vnoremap <c-r> "hy:%s/<c-r>h//gc<left><left><left>

" Ctrl-s: Easier substitue
vnoremap <c-s> :s/\%V//g<left><left><left>

" YouCompleteMe Python
"nnoremap <silent> <Leader>d :YcmCompleter GoToDefinition<cr>
nnoremap <silent> <Leader>d :BD<cr>
nnoremap <silent> <Leader>g :YcmCompleter GoToDefinitionElseDeclaration<cr>
let g:ycm_goto_buffer_command = 'vertical-split'
" let g:pymode_rope_goto_definition_bind = '<Leader>g'

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
" File Explorer {{{
noremap <leader>x :Ex<CR>

" }}}


" Buffer Explorer {{{
" nnoremap <leader>b :CtrlPBuffer<CR>

" }}}


" Bexec {{{
" nnoremap <leader>r :Bexec<cr>
" nnoremap <leader>R :BexecCloseOut<cr>

" }}}


" Buffer Traversal {{{

" derived from shell commands (Ctrl-b is back a char in command line)
nnoremap <silent> <Leader>p :call PrevBufferOrQuickfix()<CR>
nnoremap <silent> <Leader>n :call NextBufferOrQuickfix()<CR>


nnoremap <silent> <Leader>c :BB<CR>
nnoremap <silent> <Leader><BS> :BB<CR>
nnoremap <silent> <Leader><Del> :BB<CR>
" nnoremap <Leader><BS> :bdelete<CR>
" nnoremap <Leader><Del> :bdelete<CR>

" }}}

" Easy <esc> {{{
"imap <C-c> <esc>
"imap jk <esc>
"imap hl <esc>
" nnoremap <C-c> :if getwinvar(winnr("#"), "&pvw") <Bar> pclose <Bar> endif<CR>

" }}}


" Traversal
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l


nnoremap <C-=> <C-w>=

map ;] :bnext<CR>
map ;[ :bprev<CR>
" nnoremap <C-c> :close<CR>

" Moving
" No ctrl-shift sensitivity in vim (or case sensitivity with ascii at all?)
" nnoremap <C-S-h> <C-w>H
" nnoremap <C-S-j> <C-w>J
" nnoremap <C-S-k> <C-w>K
" nnoremap <C-S-l> <C-w>L

" Splitting
" nnoremap <C-n> :SplitWindow<CR>
"
" nnoremap <C-Space> :ChangeLayout<CR>

" }}}
"
" Gif config
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

" vim-multiple-cursors
let g:multi_cursor_quit_key='<C-c>'
map <C-c> :call multiple_cursors#quit()<CR>
