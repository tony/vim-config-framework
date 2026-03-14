set nomore

if empty(get(g:, 'vim_suite', ''))
  let s:error = 'Missing g:vim_suite'
  if !empty(get(g:, 'vim_test_result_file', ''))
    call writefile([s:error], g:vim_test_result_file)
  endif
  cquit 2
endif

execute 'source' fnameescape(lib#ConfigPath('tests/vim/helpers.vim'))

try
  execute 'source' fnameescape(g:vim_suite)
catch
  call assert_report('Failed to source suite ' . g:vim_suite . ': ' . v:exception)
endtry

" Ensure startup hooks like OnLoadFZF have run before suite assertions.
silent! doautocmd <nomodeline> VimEnter

let s:tests = sort(filter(getcompletion('Test_', 'function'), 'v:val =~# "^Test_"'))
if empty(s:tests)
  call assert_report('No Test_* functions found in ' . g:vim_suite)
endif

for s:test in s:tests
  let s:test_name = substitute(s:test, '()$', '', '')
  let s:setup_ok = 1

  try
    if exists('*SetUp')
      call SetUp()
    endif
  catch
    let s:setup_ok = 0
    call assert_report('SetUp failed for ' . s:test . ': ' . v:exception)
  endtry

  try
    if s:setup_ok
      call call(function(s:test_name), [])
    endif
  catch
    call assert_report('Unhandled exception in ' . s:test_name . '(): ' . v:exception)
  finally
    try
      if exists('*TearDown')
        call TearDown()
      endif
    catch
      call assert_report('TearDown failed for ' . s:test . ': ' . v:exception)
    endtry

    call VimTestCleanup()
    call VimTestReset()
  endtry
endfor

if !empty(get(g:, 'vim_test_result_file', ''))
  call writefile(v:errors, g:vim_test_result_file)
endif

if len(v:errors)
  cquit 1
endif

qa!
