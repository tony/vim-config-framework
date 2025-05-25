" Test file type settings

" Test that filetype settings are applied correctly
function! TestFiletypeSettings(ft, expected_sw, expected_ts, expected_expand)
  execute 'set filetype=' . a:ft
  let actual_sw = &shiftwidth
  let actual_ts = &tabstop
  let actual_expand = &expandtab
  
  call TestAssert(actual_sw == a:expected_sw, 
    \ printf('%s: shiftwidth=%d (expected %d)', a:ft, actual_sw, a:expected_sw))
  call TestAssert(actual_ts == a:expected_ts,
    \ printf('%s: tabstop=%d (expected %d)', a:ft, actual_ts, a:expected_ts))
  call TestAssert(actual_expand == a:expected_expand,
    \ printf('%s: expandtab=%d (expected %d)', a:ft, actual_expand, a:expected_expand))
endfunction

" Test a few key filetypes
call TestFiletypeSettings('javascript', 2, 2, 1)
call TestFiletypeSettings('python', 4, 4, 1)
call TestFiletypeSettings('go', 4, 8, 1)
call TestFiletypeSettings('vim', 2, 8, 1)

echom "PASS: File type settings test completed"
quit