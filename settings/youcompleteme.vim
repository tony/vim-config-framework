" YouCompleteMe Python
" https://github.com/Valloric/YouCompleteMe/issues/36#issuecomment-40921899
if neobundle#tap('youcompleteme')
  function! neobundle#hooks.on_post_source(bundle)

    "nnoremap <silent> <Leader>d :YcmCompleter GoToDefinition<cr>
    nnoremap <silent> <Leader>g :YcmCompleter GoToDefinitionElseDeclaration<cr>
    let g:ycm_goto_buffer_command = 'vertical-split'
    " let g:pymode_rope_goto_definition_bind = '<Leader>g'

    let g:ycm_register_as_syntastic_checker = 1
    let g:ycm_cache_omnifunc = 0
    set completeopt-=preview


    " au FileType python setlocal completeopt-=preview " The reason to deactivate jedi#auto_vim_configuration
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_autoclose_preview_window_after_insertion = 1
    let g:ycm_autoclose_preview_window_after_completion = 1
    let g:ycm_add_preview_to_completeopt = 1
    " let g:ycm_auto_trigger = 0
    let g:ycm_key_invoke_completion = '<C-n>'
    let g:ycm_filetype_blacklist =
          \ get( g:, 'ycm_filetype_blacklist',
          \   get( g:, 'ycm_filetypes_to_completely_ignore', {
          \     'notes' : 1,
          \     'markdown' : 1,
          \     'text' : 1,
          \     'unite' : 1,
          \     'vimfiler' : 1,
          \     'nerdtree' : 1,
          \ } ) )

    " Thanks http://stackoverflow.com/a/22253548
    " make YCM compatible with UltiSnips (using supertab)
    let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  endfunction

  call neobundle#untap()
endif
