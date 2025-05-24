" Environment {

    " Platform idenfitication {
        " Only UNIXLIKE() is used in the codebase
        silent function! UNIXLIKE()
            return !(has('win16') || has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        " nocompatible is already set in vimrc
        if !UNIXLIKE()
            set shell=/bin/sh
        endif
    " }
" }

" Function to source only if file exists {
function! lib#SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
" }

" Function to source all .vim files in directory {
function! lib#SourceDirectory(file)
  for s:fpath in split(globpath(a:file, '*.vim'), '\n')
    exe 'source' s:fpath
  endfor
endfunction

function! lib#ColorSchemeExists(colorscheme)
  try
      exe 'colorscheme' a:colorscheme
      return 1
  catch /^Vim\%((\a\+)\)\=:E185/
      return 0
  endtry
endfunction
