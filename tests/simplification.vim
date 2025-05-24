" Test to validate simplification opportunities

" Test duplicate SourceIfExists functions
let s:count = 0
if exists('*SourceIfExists')
  let s:count += 1
endif
if exists('*lib#SourceIfExists')
  let s:count += 1
endif
call TestAssert(s:count >= 1, 'At least one SourceIfExists function exists')
echom "INFO: Found " . s:count . " SourceIfExists implementations"

" Test ALE settings locations
let s:ale_settings = []
if exists('g:ale_set_loclist')
  call add(s:ale_settings, 'ale_set_loclist')
endif
if exists('g:ale_set_quickfix')
  call add(s:ale_settings, 'ale_set_quickfix')
endif
if exists('g:ale_linters_explicit')
  call add(s:ale_settings, 'ale_linters_explicit')
endif
if exists('g:ale_set_highlights')
  call add(s:ale_settings, 'ale_set_highlights')
endif
echom "INFO: Found " . len(s:ale_settings) . " ALE settings: " . join(s:ale_settings, ', ')

" Test ignore patterns duplication
let s:ignore_lists = 0
if exists('g:NERDTreeIgnore')
  let s:ignore_lists += 1
endif
if exists('&wildignore')
  let s:ignore_lists += 1
endif
if exists('g:netrw_list_hide')
  let s:ignore_lists += 1
endif
if exists('g:vimfiler_ignore_pattern')
  let s:ignore_lists += 1
endif
echom "INFO: Found " . s:ignore_lists . " ignore pattern lists"

" Test platform functions usage
let s:platform_funcs = ['lib#platform#OSX', 'lib#platform#LINUX', 'lib#platform#WINDOWS', 'lib#platform#CYGWIN', 'lib#platform#UNIXLIKE']
let s:unused = []
for func in s:platform_funcs
  if exists('*' . func)
    " Could grep for usage here, but for now just report existence
    call add(s:unused, func)
  endif
endfor
if len(s:unused) > 0
  echom "INFO: Platform functions defined: " . join(s:unused, ', ')
endif

quit