function! Test_runs_with_hermetic_roots() abort
  call assert_true(lib#IsTestMode(), 'Expected test mode to be enabled')
  call assert_equal(lib#ResolvePath(g:vim_config_root), lib#ConfigRoot())
  call assert_equal(lib#ResolvePath(g:vim_plugin_root), lib#PluginRoot())
  call assert_equal(lib#ResolvePath(g:vim_state_root), lib#StateRoot())
  call VimTestAssertContains(g:fzf_history_dir, lib#StateRoot(), 'fzf history dir should live under the test state root')
  call assert_true(isdirectory(g:fzf_history_dir), 'Expected fzf history directory to exist')
endfunction

function! Test_registers_core_plugins_and_commands() abort
  call assert_true(exists('g:plugs') == 1, 'Expected vim-plug registry to be available')

  for l:name in ['ale', 'fzf', 'fzf.vim', 'vim-rooter', 'nerdtree', 'coc.nvim']
    call assert_true(has_key(g:plugs, l:name), 'Missing plug entry: ' . l:name)
  endfor

  for l:command in ['PlugInstall', 'Rooter', 'NERDTreeFocus', 'CocInfo']
    call VimTestAssertCommand(l:command)
  endfor
endfunction

function! Test_selects_a_configured_colorscheme() abort
  let l:allowed = [
        \ 'tokyonight-moon',
        \ 'tokyonight',
        \ 'catppuccin_mocha',
        \ 'gruvbox',
        \ 'gruvbox-material',
        \ 'everforest',
        \ 'desert-warm-256',
        \ 'desert',
        \ ]

  call assert_true(exists('g:colors_name') == 1, 'Expected colors_name to be set')
  call assert_true(index(l:allowed, g:colors_name) >= 0, 'Unexpected colorscheme: ' . g:colors_name)
endfunction

function! Test_sources_absolute_paths_inside_temp_worktrees() abort
  let l:tempdir = VimTestTempDir('source-if-exists')
  let l:script = VimTestWriteFile(
        \ l:tempdir . '/absolute-source.vim',
        \ ['let g:vim_test_absolute_source = "loaded"']
        \ )

  unlet! g:vim_test_absolute_source
  call lib#SourceIfExists(l:script)

  call assert_equal('loaded', get(g:, 'vim_test_absolute_source', ''), 'Expected absolute temp path to be sourced')
endfunction
