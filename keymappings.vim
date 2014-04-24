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
nnoremap <leader><tab> :call NerdTreeFindPrevBuf()<cr>

let NERDTreeMapUpdir='-'
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
" vnoremap <c-c> y`]

" Ctrl-r: Easier search and replace
vnoremap <c-r> "hy:%s/<c-r>h//gc<left><left><left>

" Ctrl-s: Easier substitue
vnoremap <c-s> :s/\%V//g<left><left><left>


nnoremap <silent> <Leader>d :YcmCompleter GoToDefinition<cr>
nnoremap <silent> <Leader>g :YcmCompleter GoToDeclaration<cr>
nnoremap <silent> <Leader>p :bprev<cr>
nnoremap <silent> <Leader>n :bnext<cr>

" Map space to the prefix for Unite
" General fuzzy search
" nnoremap <silent> <space><space> :<C-u>CtrlPMixed<CR>

" nnoremap <silent> <space>o :<C-u>CtrlPBufTag<CR>

" nnoremap <silent> <space>b :<C-u>CtrlPBuffer<CR>
" nnoremap <silent> <space>m :<C-u>CtrlPMRU<CR>


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
" nnoremap <leader>p :bprevious<CR>
" nnoremap <leader>n :bnext<CR>
" nnoremap <leader>d :bdelete<CR>

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
" nnoremap <C-c> :close<CR>

" Moving
" No ctrl-shift sensitivity in vim (or case sensitivity with ascii at all?)
" nnoremap <C-S-h> <C-w>H
" nnoremap <C-S-j> <C-w>J
" nnoremap <C-S-k> <C-w>K
" nnoremap <C-S-l> <C-w>L

" Splitting
nnoremap <C-n> :SplitWindow<CR>
" nnoremap <C-Space> :ChangeLayout<CR>

" }}}
