if exists('g:loaded_vim_test_helpers')
  finish
endif
let g:loaded_vim_test_helpers = 1

function! VimTestReset() abort
  let g:vim_test_cleanup_paths = []
  let g:vim_test_original_cwd = getcwd()
endfunction

function! VimTestRegisterCleanup(path) abort
  let l:path = fnamemodify(a:path, ':p')
  if index(g:vim_test_cleanup_paths, l:path) < 0
    call add(g:vim_test_cleanup_paths, l:path)
  endif
  return l:path
endfunction

function! VimTestTempDir(...) abort
  let l:prefix = a:0 ? a:1 : 'vim-test'
  let l:path = tempname() . '-' . l:prefix
  call mkdir(l:path, 'p')
  return VimTestRegisterCleanup(l:path)
endfunction

function! VimTestWriteFile(path, lines) abort
  call mkdir(fnamemodify(a:path, ':h'), 'p')
  call writefile(type(a:lines) == v:t_string ? [a:lines] : a:lines, a:path)
  return VimTestRegisterCleanup(a:path)
endfunction

function! VimTestOpen(path) abort
  execute 'edit' fnameescape(a:path)
  return expand('%:p')
endfunction

function! VimTestCleanup() abort
  if exists('g:vim_test_original_cwd') && isdirectory(g:vim_test_original_cwd)
    execute 'cd' fnameescape(g:vim_test_original_cwd)
  endif

  silent! %bwipe!

  for l:path in reverse(copy(get(g:, 'vim_test_cleanup_paths', [])))
    if isdirectory(l:path)
      call delete(l:path, 'rf')
    else
      call delete(l:path)
    endif
  endfor

  let g:vim_test_cleanup_paths = []
endfunction

function! VimTestAssertContains(haystack, needle, message) abort
  call assert_notequal(-1, stridx(a:haystack, a:needle), a:message)
endfunction

function! VimTestAssertCommand(name) abort
  call assert_true(exists(':' . a:name) > 0, 'Expected command ' . a:name)
endfunction

function! VimTestNormalizePath(path) abort
  return substitute(fnamemodify(a:path, ':p'), '/\+$', '', '')
endfunction

function! VimTestAssertFiletype(path, expected) abort
  call VimTestOpen(a:path)
  call assert_equal(a:expected, &filetype, 'Unexpected filetype for ' . a:path)
  bwipe!
endfunction

call VimTestReset()
