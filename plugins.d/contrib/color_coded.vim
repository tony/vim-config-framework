if !has('nvim')
  Plug 'jeaye/color_coded', { 
      \ 'build': {
      \   'unix': 'cmake . && make && make install',
      \   'linux': 'cmake . -DCUSTOM_CLANG=1 -DLLVM_ROOT_PATH=/usr -DLLVM_INCLUDE_PATH=/usr/lib/llvm-3.4/include'
      \ },
      \ 'for' : ['c', 'cpp', 'objc', 'objcpp'],
      \ 'build_commands' : ['cmake', 'make'],
      \ 'external_commands' : ['clang'],
      \ 'disabled' : has('nvim')
      \}
endif
