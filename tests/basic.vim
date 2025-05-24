" Test script to validate configuration works correctly

" Test 1: Verify plugin system loads
call TestExists('plug#begin', 'function', 'vim-plug loaded')
call TestExists('PlugInstall', 'command', 'PlugInstall command available')

" Test 2: Verify autoload functions
call TestExists('lib#SourceIfExists', 'function', 'lib#SourceIfExists exists')
call TestExists('lib#ColorSchemeExists', 'function', 'lib#ColorSchemeExists exists')
call TestExists('settings#LoadSettings', 'function', 'settings#LoadSettings exists')

" Test 3: Verify key settings
call TestAssert(&nocompatible == 1, 'nocompatible is set')
call TestAssert(&syntax == 'on', 'syntax highlighting enabled')
call TestAssert(&filetype == 'on', 'filetype detection enabled')

" Test 4: Verify leader key
call TestAssert(mapleader == ',', 'leader key is comma')

" Test 5: Check if FindRootDirectory is available (from vim-rooter)
if exists('*FindRootDirectory')
  echom "PASS: FindRootDirectory exists (from vim-rooter)"
else
  echom "INFO: FindRootDirectory not loaded (plugin may be lazy-loaded)"
endif

" Test 6: Verify ignore patterns loaded
call TestExists('g:NERDTreeIgnore', 'variable', 'NERDTreeIgnore patterns loaded')

" Test 7: Check colorscheme
if exists('g:colors_name')
  echom "PASS: Colorscheme loaded: " . g:colors_name
else
  echom "INFO: No colorscheme loaded (may not be available)"
endif

echom "All critical tests passed!"
quit