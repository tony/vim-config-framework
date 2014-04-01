" http://stackoverflow.com/questions/9990219/vim-whats-the-difference-between-let-and-set
" Borrows from https://github.com/terryma/dotfiles/blob/master/.vimrc
" Borrows from https://github.com/klen/.vim

"" -------------------
" Look and Feel
" -------------------

let g:SESSION_DIR   = $HOME.'/.cache/vim/sessions'


" Don't reset twice on reloading - 'compatible' has SO many side effects.
if !exists('s:loaded_my_vimrc')
  source ~/.vim/bundles.vim
  source ~/.vim/functions.vim
  source ~/.vim/settings.vim
  source ~/.vim/autocmd.vim
  source ~/.vim/unite.vim
  source ~/.vim/keymappings.vim
  source ~/.vim/ignore.vim
endif

" from functions.vim
com! -nargs=0 SeeTab :call SeeTab()

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


let g:tagbar_width = 35
"===============================================================================
"" NERDTree
"===============================================================================

" Close nerdtree on file open
let NERDTreeQuitOnOpen = 1

" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline=1

let NERDTreeShowHidden=1

let NERDTreeHijackNetrw=0

" Use a single click to fold/unfold directories and a double click to open
" files
let NERDTreeMouseMode=2

" let NERDTreeIgnore
" See ignore.vim

let g:NERDTreeWinSize = 31

" Awesome vim {{{

" based off http://stackoverflow.com/questions/7135985/detecting-split-window-dimensions
" command! SplitWindow call s:SplitWindow()
" function! s:SplitWindow()
  " let l:height=winheight(0) * 2
  " let l:width=winwidth(0)
  " if (l:height > l:width)
     " :split
  " else
     " :vsplit
  " endif
" endfunction

" " based off http://stackoverflow.com/questions/7135985/detecting-split-window-dimensions
" command! ChangeLayout call s:ChangeLayout()
" function! s:ChangeLayout()
  " let l:height=winheight(0) * 2
  " let l:width=winwidth(0)
  " if (l:height > l:width)
    " <C-w> <C-H>
  " else
    " <C-w> <C-J>
  " endif
" endfunction



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
" Vimfiler
"===============================================================================

" TODO Look into Vimfiler more
" Example at: https://github.com/hrsh7th/dotfiles/blob/master/vim/.vimrc

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_tree_leaf_icon = '  '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '✓'
" let g:vimfiler_readonly_file_icon = ' '
let g:my_vimfiler_explorer_name = 'explorer'
let g:my_vimfiler_winwidth = 30
let g:vimfiler_safe_mode_by_default = 1
let g:vimfiler_directory_display_top = 1
let g:vimfiler_force_overwrite_statusline = 0

" let g:vimfiler_ignore_pattern
" See ignore.vim

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()


function! s:vimfiler_settings()
  nmap     <buffer><expr><CR>  vimfiler#smart_cursor_map("\<PLUG>(vimfiler_expand_tree)", "e")
  nunmap <buffer> N
  " Traversal
  nnoremap <buffer> <C-h> <C-w>h
  nnoremap <buffer> <C-j> <C-w>j
  nnoremap <buffer> <C-k> <C-w>k
  nnoremap <buffer> <C-l> <C-w>l
  " nnoremap <C-c> :close<CR>
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
" Local Settings
"===============================================================================

try
  source ~/.vimrc.local
catch
endtry



" let g:netrw_hide=1 
" let g:netrw_list_hide=
" See ignore.vim

" Enable filetype detection
"filetype on
"filetype plugin indent on


let g:NERDCustomDelimiters = {
  \ 'sls': { 'left': '#' },
\ }



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

"source ~/.vim/neocompleterc.vim





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

let g:riv_auto_format_table = 0
let g:airline_powerline_fonts = 1

" Or instead of gggqG, use <Visual>gq to format only the highlighted lines 
" (i.e. gq after using shift-v + cursor moves to set up a linewise visual 
" area). 
" https://groups.google.com/d/msg/vim_use/XzObYsZpUrQ/svirOL-N0DUJ

let g:pymode_virtualenv=1 " Auto fix vim python paths if virtualenv enabled        
let g:pymode_folding=1  " Enable python folding 
let g:pymode_rope = 0


let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
                        \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = "left"
let g:jedi#documentation_command = "<leader>k"
let g:jedi#usages_command = "<leader>u"
let g:SuperTabLongestHighlight = 0

" https://github.com/davidhalter/jedi-vim/issues/179
let g:jedi#popup_select_first = 0
let g:jedi#auto_vim_configuration = 1
" au FileType python setlocal completeopt-=preview " The reason to deactivate jedi#auto_vim_configuration
let g:ycm_confirm_extra_conf = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_filetype_blacklist =
  \ get( g:, 'ycm_filetype_blacklist',
  \   get( g:, 'ycm_filetypes_to_completely_ignore', {
  \     'notes' : 1,
  \     'markdown' : 1,
  \     'text' : 1,
  \     'unite' : 1,
  \ } ) )


source ~/.vim/colors.vim

if !exists('s:loaded_my_vimrc')
  let s:loaded_my_vimrc = 1
endif


if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
