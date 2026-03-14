function! Test_applies_expected_global_options() abort
  call assert_true(&hidden, 'hidden should be enabled')
  call assert_true(&lazyredraw, 'lazyredraw should be enabled')
  call assert_equal(',', get(g:, 'mapleader', ''))
  call assert_equal(',', get(g:, 'maplocalleader', ''))
  call assert_equal(1, index(['number', 'yes'], &signcolumn) >= 0, 'Unexpected signcolumn value: ' . &signcolumn)

  if exists('+termguicolors')
    call assert_true(&termguicolors, 'termguicolors should be enabled')
  endif
endfunction

function! Test_installs_navigation_mappings() abort
  let l:nerdtree = maparg('<leader>e', 'n', 0, 1)
  call assert_equal(':NERDTreeFocus<CR>', get(l:nerdtree, 'rhs'))

  let l:quickfix = maparg('<leader>q', 'n', 0, 1)
  call assert_equal(':cwindow<CR>', get(l:quickfix, 'rhs'))

  let l:left = maparg('<C-h>', 'n', 0, 1)
  call assert_equal('<C-w>h', get(l:left, 'rhs'))
endfunction

function! Test_propagates_ignore_lists() abort
  call VimTestAssertContains(&wildignore, 'node_modules', 'wildignore should include node_modules')
  call VimTestAssertContains(&wildignore, '*.pyc', 'wildignore should include *.pyc')
  call assert_true(index(g:NERDTreeIgnore, '\.pyc$') >= 0, 'NERDTree ignore list should include pyc files')
  call VimTestAssertContains(g:netrw_list_hide, '.git,', 'netrw hide list should include .git')
  call VimTestAssertContains(g:netrw_list_hide, 'node_modules,', 'netrw hide list should include node_modules')
endfunction
