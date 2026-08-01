function! Test_finds_project_roots_for_nested_files() abort
  let l:root = VimTestTempDir('rooter-project')
  call mkdir(l:root . '/.git', 'p')
  call VimTestWriteFile(l:root . '/src/app.py', ['print("hello")'])

  call VimTestOpen(l:root . '/src/app.py')
  call assert_equal(VimTestNormalizePath(l:root), VimTestNormalizePath(FindRootDirectory()))
endfunction

function! Test_rooter_auto_changes_to_project_root() abort
  let l:root = VimTestTempDir('rooter-command')
  call mkdir(l:root . '/.git', 'p')
  call VimTestWriteFile(l:root . '/pkg/app.py', ['print("hello")'])

  call VimTestOpen(l:root . '/pkg/app.py')
  call assert_equal(VimTestNormalizePath(l:root), VimTestNormalizePath(getcwd()), 'Auto-rooter should change to the detected project root on BufEnter')
endfunction

function! Test_registers_project_search_commands() abort
  call VimTestAssertCommand('FZFRoot')

  if executable('rg')
    call VimTestAssertCommand('Rg')
    call VimTestAssertCommand('RG')
  endif
endfunction
