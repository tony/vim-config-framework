  let s:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
  if isdirectory(s:clang_library_path)
    let g:clang_library_path=s:clang_library_path
  endif
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif          
  let g:neocomplete#force_omni_input_patterns.c =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
  let g:neocomplete#force_omni_input_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
  let g:neocomplete#force_omni_input_patterns.objc =
        \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
  let g:neocomplete#force_omni_input_patterns.objcpp =
        \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)\|\h\w*::\w*'
  let g:clang_complete_auto = 0
  let g:clang_auto_select = 0
  let g:clang_omnicppcomplete_compliance = 0
  let g:clang_make_default_keymappings = 0
  let g:clang_use_library = 1
  let g:clang_jumpto_declaration_key = '<leader>g'
  let g:clang_complete_copen=1
  let g:clang_hl_errors=1

