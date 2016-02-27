function! StartJedi()

    let g:jedi#use_tabs_not_buffers = 0
    let g:jedi#use_splits_not_buffers = "right"
    let g:jedi#documentation_command = "<leader>h"
    let g:jedi#usages_command = "<leader>u"
    let g:jedi#completions_command = "<C-N>"

    " https://github.com/davidhalter/jedi-vim/issues/179
    let g:jedi#popup_select_first = 0
    let g:jedi#auto_vim_configuration = 0

    let g:jedi#popup_on_dot = 1
    " Improve performance by setting this to 0:
    " https://github.com/davidhalter/jedi-vim/issues/163#issuecomment-73343003
    let g:jedi#show_call_signatures = 0

    if exists(':NeoCompleteEnable')
      " https://github.com/Shougo/neocomplete.vim/issues/18
      let g:jedi#completions_enabled=0
    endif

    if exists(':DeopleteEnable')
      let g:jedi#completions_enabled = 0
      let g:jedi#auto_vim_configuration = 0
      let g:jedi#smart_auto_mappings = 0
      let g:jedi#show_call_signatures = 0
    endif

    au FileType python setlocal completeopt-=preview " The reason to deactivate jedi#auto_vim_configuration
    augroup PreviewOnBottom
      autocmd InsertEnter * set splitbelow
      autocmd InsertLeave * set splitbelow!
    augroup END

    autocmd FileType python setlocal omnifunc=jedi#completions
endfunction

autocmd! User jedi-vim call StartJedi()
