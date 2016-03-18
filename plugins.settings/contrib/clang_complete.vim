function! StartClangComplete() 
  let s:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
  if isdirectory(s:clang_library_path)
    let g:clang_library_path=s:clang_library_path
  endif

  let g:clang_complete_auto = 1
  let g:clang_auto_select = 0
  let g:clang_omnicppcomplete_compliance = 0
  let g:clang_make_default_keymappings = 1
  let g:clang_use_library = 1
  let g:clang_jumpto_declaration_key = '<leader>g'
  au FileType c,cpp,objc,objcpp setl omnifunc=clang_complete#ClangComplete
endfunction

call PlugOnLoad('clang_complete', 'call StartClangComplete()')
