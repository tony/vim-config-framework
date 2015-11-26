" http://stackoverflow.com/questions/9990219/vim-whats-the-difference-between-let-and-set
" Borrows from https://github.com/terryma/dotfiles/blob/master/.vimrc
" Borrows from https://github.com/klen/.vim

"" -------------------
" Look and Feel
" -------------------

let g:SESSION_DIR   = $HOME.'/.cache/vim/sessions'


" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
        silent function! FREEBSD()
          let s:uname = system("uname -s")
          return (match(s:uname, 'FreeBSD') >= 0)
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

" }

" Use before config if available {
    if filereadable(expand("~/.vimrc.before"))
        source ~/.vimrc.before
    endif
" }

" Don't reset twice on reloading - 'compatible' has SO many side effects.
if !exists('s:loaded_my_vimrc')
  source ~/.vim/bundles.vim
  source ~/.vim/functions.vim
  source ~/.vim/quickfix.vim
  source ~/.vim/settings.vim
  source ~/.vim/autocmd.vim
  source ~/.vim/keymappings.vim
  source ~/.vim/encoding.vim

  for fpath in split(globpath('~/.vim/settings/', '*.vim'), '\n')
    exe 'source' fpath
  endfor
  source ~/.vim/ignore.vim
  source ~/.vim/rice.vim
endif


"===============================================================================
" Local Settings
"===============================================================================

source ~/.vim/colors.vim


if has('nvim')
  runtime! plugin/python_setup.vim
endif

" Use fork vimrc if available {
    if filereadable(expand("~/.vimrc.fork"))
        source ~/.vimrc.fork
    endif
" }

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }

" FreeBSD-specific terminal fixes
if FREEBSD()
  if filereadable(expand("~/.vim/compat/freebsd.vim"))
    source ~/.vim/compat/freebsd.vim
  endif
  if filereadable(expand("/usr/src/tools/tools/editing/freebsd.vim"))
    source /usr/src/tools/tools/editing/freebsd.vim
  endif
end

" Use local gvimrc if available and gui is running {
    if has('gui_running')
        if filereadable(expand("~/.gvimrc.local"))
            source ~/.gvimrc.local
        endif
    endif
" }

if !exists('s:loaded_my_vimrc')
  let s:loaded_my_vimrc = 1
endif
