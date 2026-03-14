function! Test_registers_conditional_plugins_from_local_tools() abort
  let l:conditional_plugins = {
        \ 'ag': ['ag.vim'],
        \ 'cargo': ['rust.vim'],
        \ 'docker': ['Dockerfile.vim'],
        \ 'git': ['tig-explorer.vim', 'vim-fugitive'],
        \ 'mix': ['vim-elixir'],
        \ 'node': ['typescript-vim', 'vim-html-template-literals', 'vim-jsx-improve', 'vim-mdx-js', 'vim-vue', 'yats.vim'],
        \ 'pipenv': ['vim-toml'],
        \ 'psql': ['pgsql.vim'],
        \ 'terraform': ['vim-terraform'],
        \ 'tmux': ['tmux-complete.vim'],
        \ }

  for [l:command, l:plugins] in items(l:conditional_plugins)
    for l:plugin in l:plugins
      let l:expected = executable(l:command) ? 1 : 0
      call assert_equal(l:expected, has_key(g:plugs, l:plugin), printf('Unexpected registration for %s via %s', l:plugin, l:command))
    endfor
  endfor
endfunction

function! Test_keeps_plugin_specific_defaults() abort
  call assert_equal(1, g:ale_fix_on_save)
  call assert_equal(1, g:ale_hover_cursor)
  call assert_equal(v:false, g:copilot_filetypes.markdown)
  call assert_equal(v:false, g:copilot_filetypes.rst)
  call assert_equal(v:false, g:copilot_filetypes.zsh)
  call assert_true(has_key(g:plugs, 'wilder.nvim'))

  if has('nvim')
    call assert_true(has_key(g:plugs, 'tokyonight.nvim'))
  else
    call assert_true(has_key(g:plugs, 'nvim-yarp'))
    call assert_true(has_key(g:plugs, 'vim-hug-neovim-rpc'))
  endif
endfunction
