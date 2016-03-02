function! StartClangComplete() 
  let s:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
  if isdirectory(s:clang_library_path)
    let g:clang_library_path=s:clang_library_path
  endif

  let g:clang_complete_auto = 0
  let g:clang_auto_select = 0
  let g:clang_omnicppcomplete_compliance = 0
  let g:clang_make_default_keymappings = 0
  " let g:clang_use_library = 1
endfunction

autocmd! User clang_complete call StartClangComplete()
