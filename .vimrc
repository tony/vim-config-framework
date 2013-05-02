" -------------------
" Look and Feel
" -------------------

" Don't reset twice on reloading - 'compatible' has SO many side effects.
if !exists('s:loaded_my_vimrc')
  source ~/.vim/bundles.vim

  function NerdTreeFindPrevBuf()
    if (bufname('%') == '__Tag_List__') || (bufname('%') == '__Tagbar__')
      wincmd p " previous window
      if !filereadable(bufname('%'))
              wincmd h " mv one window to the left
      endif
      execute ':NERDTreeFind'
    else
      if !filereadable(bufname('%'))
        echo "Previous buf not valid or readable file."
        execute ':NERDTree ' . getcwd()
      else
        execute ':NERDTreeFind'
      endif
    endif
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


" Show line numbers
nnoremap <leader>l :set number!<CR>


" NERDTree settings {{{

" Close nerdtree on file open
let NERDTreeQuitOnOpen = 1

let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\~$', '\.log$', '\.log\.\d*$']

" Quit on opening files from the tree
let NERDTreeQuitOnOpen=1

" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline=1

" Use a single click to fold/unfold directories and a double click to open
" files
let NERDTreeMouseMode=2

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
          \ '\.o$', '\.so$', '\.egg$', '^\.git$' ]

nnoremap <leader>e :call NerdTreeFindPrevBuf()<CR>
nnoremap <leader>E :NERDTreeClose<CR>

" }}}


" Hey magellen, my dad works at a dealership man! {{{
nnoremap <leader>t :TagbarOpen fj<cr>
nnoremap <leader>T :TagbarClose<cr>

" }}}


" File Explorer {{{
nnoremap <leader>x :Explore<CR>

" }}}


" Buffer Explorer {{{
nnoremap <leader>b :BufExplorer<CR>

" }}}


" Bexec {{{
nnoremap <leader>r :Bexec<cr>
nnoremap <leader>R :BexecCloseOut<cr>

" }}}


" Buffer Traversal {{{
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>n :bnext<CR>
nnoremap <leader>d :BD<CR>

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


" JS Beautify {{{
autocmd FileType javascript noremap <buffer> <leader>f :call JsBeautify()<CR>
" for html
autocmd FileType html noremap <buffer> <leader>f :call HtmlBeautify()<CR>
autocmd FileType mustache noremap <buffer> <leader>f :call HtmlBeautify()<CR>
" for css or scss
autocmd FileType css noremap <buffer> <leader>f :call CSSBeautify()<CR>

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

" Settings {{{
set nocompatible               " Use Vim defaults instead of 100% vi compatibility
set whichwrap=<,>              " Cursor key move the cursor to the next/previous line if pressed at the end/beginning of a line
set backspace=indent,eol,start " more powerful backspacing
set viminfo='20,\"50           " read/write a .viminfo file, don't store more than
set history=100                " Keep 100 lines of command line history
set incsearch                  " Incremental search
set hidden                     " Hidden allows to have modified buffers in background
set noswapfile                 " Turn off backups and files
set nobackup                   " Don't keep a backup file
set number		       " Line numbers
set modeline
set modelines=5

" no backup-files like bla~ 
set nobackup
set nowritebackup 

" }}}

" Enable filetype detection
filetype on
filetype plugin indent on

if has("autocmd")
  autocmd! BufNewFile,BufRead *.js.php,*.json set filetype=javascript
  autocmd FileType javascript  setlocal  ts=2 sw=2 sts=2 expandtab
  autocmd FileType vim  setlocal ai et sta sw=2 sts=2 keywordprg=:help
  autocmd FileType html,mustache  setlocal  ts=2 sw=2 sts=2 expandtab
  autocmd FileType sh,csh,tcsh,zsh        setlocal ai et sta sw=4 sts=4
  autocmd BufWritePost,FileWritePost ~/.Xdefaults,~/.Xresources silent! !xrdb -load % >/dev/null 2>&1

  autocmd FileType git,gitcommit setlocal foldmethod=syntax foldlevel=1
  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitrebase nnoremap <buffer> S :Cycle<CR>

  " Keep vim's cwd (Current Working Directory) set to current file. 
  autocmd BufEnter * silent! lcd %:p:h


  if (exists("b:NERDTreeType"))
    " Load NERDTree if no buffers specified
    autocmd vimenter * if !argc() | NERDTree | endif
  endif

  " Close vim if NERDTree is only window left
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

  augroup python_files "{{{
    au!

    " This function detects, based on Python content, whether this is a
    " Django file, which may enabling snippet completion for it
    fun! s:DetectPythonVariant()
        let n = 1
        while n < 50 && n < line("$")
            " check for django
            if getline(n) =~ 'import\s\+\<django\>' || getline(n) =~ 'from\s\+\<django\>\s\+import'
                set ft=python.django
                "set syntax=python
                return
            endif
            let n = n + 1
        endwhile
  " go with html
        set ft=python
    endfun

  augroup rst_files "{{{
    au!

    " Auto-wrap text around 74 chars
    autocmd filetype rst setlocal textwidth=74
    autocmd filetype rst setlocal formatoptions+=nqt
    autocmd filetype rst setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
    autocmd filetype rst setlocal cindent
    autocmd filetype rst setlocal tabstop=4
    autocmd filetype rst setlocal softtabstop=4
    autocmd filetype rst setlocal shiftwidth=4
    autocmd filetype rst setlocal shiftround
    autocmd filetype rst setlocal smartindent
    autocmd filetype rst setlocal smarttab
    autocmd filetype rst setlocal expandtab
    autocmd filetype rst setlocal autoindent

    autocmd filetype rst match ErrorMsg '\%>74v.\+'
  augroup end " }}}

    autocmd BufNewFile,BufRead *.py call s:DetectPythonVariant()
    autocmd BufNewFile,BufRead *.rst set ft=rst
  augroup end " }}}


endif

filetype plugin indent on

" default color scheme
" set t_Co=256
syntax on
colorscheme desert


let g:NERDCustomDelimiters = {
  \ 'sls': { 'left': '#' },
\ }


if !exists('s:loaded_my_vimrc')
  let s:loaded_my_vimrc = 1
endif

" enables the reading of .vimrc, .exrc and .gvimrc in the current directory.
set exrc

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

" must be written at the last. see :help 'secure'.
set secure 
