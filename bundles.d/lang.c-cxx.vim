NeoBundleLazy 'justmao945/vim-clang', {
      \ 'autoload': {
      \  'filetypes':['c', 'cpp'],
      \  'external_commands' : ['clang'],
      \ }
      \}

NeoBundleLazy 'jalcine/cmake.vim', {
      \ 'autoload': {
      \   'commands': [
      \     'CMakeBuild',
      \     'CMakeCeateClean',
      \     'CMakeClean'
      \   ],
      \  'filetypes':['c', 'cpp'],
      \  'external_commands' : ['cmake'],
      \ }
      \}


NeoBundleLazy 'jeaye/color_coded', { 
      \ 'build': {
      \   'unix': 'cmake . && make && make install',
      \   'linux': 'cmake . -DCUSTOM_CLANG=1 -DLLVM_ROOT_PATH=/usr -DLLVM_INCLUDE_PATH=/usr/lib/llvm-3.4/include'
      \ },
      \ 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] },
      \ 'build_commands' : ['cmake', 'make']
      \}

NeoBundleLazy 'rhysd/vim-clang-format',
      \ { 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] } }

NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', {'autoload':{'filetypes':['cpp']}}

NeoBundle 'justinmk/vim-syntax-extra', {
      \ 'autoload': {
      \  'filetypes':['c', 'cpp'],
      \ }
      \}
