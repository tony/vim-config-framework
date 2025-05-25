" Set shell for Windows systems
if has('win16') || has('win32') || has('win64')
    set shell=/bin/sh
endif

" Function to source only if file exists {
function! lib#SourceIfExists(file)
  if filereadable(expand(a:file))
    exe 'source' a:file
  endif
endfunction
" }


function! lib#ColorSchemeExists(colorscheme)
  try
      exe 'colorscheme' a:colorscheme
      return 1
  catch /^Vim\%((\a\+)\)\=:E185/
      return 0
  endtry
endfunction
