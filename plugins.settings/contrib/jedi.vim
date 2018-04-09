function! StartJedi()
    let g:jedi#completions_enabled = 0
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#smart_auto_mappings = 0
    au FileType python setlocal completeopt-=longest " The reason to deactivate jedi#auto_vim_configuration

    let g:jedi#use_tabs_not_buffers = 0
    let g:jedi#use_splits_not_buffers = "right"
    let g:jedi#documentation_command = "<leader>h"
    let g:jedi#usages_command = "<leader>u"
    let g:jedi#completions_command = "<C-N>"
    " Improve performance by setting this to 0:
    " https://github.com/davidhalter/jedi-vim/issues/163#issuecomment-73343003
    let g:jedi#show_call_signatures = 2

    augroup PreviewOnBottom
        autocmd InsertEnter * set splitbelow
        autocmd InsertLeave * set splitbelow!
    augroup END
endfunction

call PlugOnLoad('jedi-vim', 'call StartJedi()')
