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

" Use before config if available {
    call SourceIfExists("~/.vimrc.before")
" }

" Don't reset twice on reloading - 'compatible' has SO many side effects.
if !exists('s:loaded_my_vimrc')
  call SourceDirectory('~/.vim/quirks')

  call SourceIfExists("~/.vim/ignore.vim")
  call SourceIfExists("~/.vim/rice.vim")

  call SourceDirectory('~/.vim/settings')


  call SourceIfExists("~/.vim/plugin_loader.vim")
  call SourceDirectory('~/.vim/plugins.settings')
endif


"===============================================================================
" Local Settings
"===============================================================================

call SourceIfExists("~/.vim/colors.vim")

call SourceIfExists("~/.vimrc.local")

" FreeBSD-specific terminal fixes
if FREEBSD()
  call SourceIfExists("~/.vim/compat/freebsd.vim")
  call SourceIfExists("/usr/src/tools/tools/editing/freebsd.vim")
end

if has('gui_running')
  call SourceIfExists("~/.gvimrc.local")
endif

if !exists('s:loaded_my_vimrc')
  let s:loaded_my_vimrc = 1
endif
