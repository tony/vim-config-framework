" Map leader and localleader key to comma
let mapleader = ","
let maplocalleader = ","

" Format / indentation moved to <leader>f in autocmd.vim

" <Leader>4: Toggle between paste mode
nnoremap <silent> <leader>4 :set paste!<cr>


" thanks terryma: https://github.com/terryma/dotfiles/blob/master/.vimrc
" d: Delete into the blackhole register to not clobber the last yank
nnoremap d "_d
" dd: I use this often to yank a single line, retain its original behavior
nnoremap dd dd

" Show line numbers - simple toggles
" http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
nnoremap <silent> <leader>6 :set relativenumber!<CR>
nnoremap <silent> <leader>7 :set number!<CR>
nnoremap <silent> <leader>b :BLines<CR>



" <Leader>p: Copy the full path of the current file to the clipboard
nnoremap <silent> <Leader>p :let @+=expand("%:p")<cr>:echo "Copied current file
      \ path '".expand("%:p")."' to clipboard"<cr>

" Q: Closes the window
nnoremap Q :q<cr>


" Clear search highlight and close CoC popup if visible
nnoremap <silent> <c-c> :nohlsearch<CR>:silent! call coc#pum#visible() ? coc#pum#_close() : ""<CR>


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

" \: Toggle comment (tcomment)
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

nnoremap <silent> <Leader><BS> :BB<CR>

" Traversal
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Netrw traversal
" https://gist.github.com/danidiaz/37a69305e2ed3319bfff9631175c5d0f#file-netrw-txt-L4
augroup netrw_window_fix
    autocmd!
    autocmd filetype netrw call Set_netrw_maps()
augroup END
function! Set_netrw_maps()
    noremap <buffer> <C-l> <C-w>l
endfunction


nnoremap <C-=> <C-w>=

" Buffer navigation
nnoremap <silent> <Leader>] :bnext<CR>
nnoremap <silent> <Leader>[ :bprevious<CR>

nnoremap <leader>e :NERDTreeFocus<CR>

" Quickfix window toggles
nnoremap <leader>q :cwindow<CR>
nnoremap <C-q> :cclose<CR>
