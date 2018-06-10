" http://stackoverflow.com/questions/9990219/vim-whats-the-difference-between-let-and-set
" Borrows from https://github.com/terryma/dotfiles/blob/master/.vimrc
" Borrows from https://github.com/klen/.vim

"" -------------------
" Look and Feel
" -------------------

let g:SESSION_DIR   = $HOME.'/.cache/vim/sessions'


" Environment {

    " Platform idenfitication {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
        silent function! UNIXLIKE()
            return !WINDOWS()
        endfunction
        silent function! FREEBSD()
          let s:uname = system("uname -s")
          return (match(s:uname, 'FreeBSD') >= 0)
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !UNIXLIKE()
            set shell=/bin/sh
        endif
    " }
" }

" Function to source only if file exists {
function! SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
" }

" Function to source all .vim files in directory {
function! SourceDirectory(file)
  for s:fpath in split(globpath(a:file, '*.vim'), '\n')
    exe 'source' s:fpath
  endfor
endfunction

" Don't reset twice on reloading - 'compatible' has SO many side effects.
if !exists('s:loaded_my_vimrc')
  " todo: deconflate below
  call SourceIfExists("~/.vim/settings/settings.vim")
  call SourceIfExists("~/.vim/settings/ignore.vim")
  call SourceIfExists("~/.vim/settings/sensible.vim")

  call SourceIfExists("~/.vim/settings/keymappings.vim")
  call SourceIfExists("~/.vim/plugin_loader.vim")
  call SourceIfExists('~/.vim/plugins.settings/pymode.vim')
  call SourceIfExists('~/.vim/plugins.settings/NERDTree.vim')
  call SourceIfExists('~/.vim/plugins.settings/base16-colors.vim')
  call SourceIfExists('~/.vim/plugins.settings/fzf.vim')
  call SourceIfExists('~/.vim/plugins.settings/vim-rooter.vim')
  " Disable netrw.vim
  let g:loaded_netrwPlugin = 1
endif


" turn off jedi (python completion)
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0

" ALE
let g:ale_set_loclist = 0 let g:ale_set_quickfix = 1
let g:ale_list_window_size = 5  " Show 5 lines of errors (default: 10)

" fix backspace
" http://vim.wikia.com/wiki/Backspace_and_delete_problems#Backspace_key_won.27t_move_from_current_line
set backspace=2 " make backspace work like most other programs

"===============================================================================
" Local Settings
"===============================================================================

call SourceIfExists("~/.vimrc.local")

" Don't create swap files
set nobackup       "no backup files
set nowritebackup  "only in case you don't want a backup file while editing
set noswapfile     "no swap files

" Fix E353: Nothing in register "
" Writes to the unnamed register also writes to the * and + registers. This
" makes it easy to interact with the system clipboard
if has ('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

if !exists('s:loaded_my_vimrc')
  let s:loaded_my_vimrc = 1
endif
