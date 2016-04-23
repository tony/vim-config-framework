function! StartJedi()

    if exists(':NeoCompleteEnable') || exists(':DeopleteEnable')
        " https://github.com/Shougo/neocomplete.vim/issues/18
        autocmd FileType python setlocal omnifunc=jedi#completions
        let g:jedi#completions_enabled = 0
        let g:jedi#auto_vim_configuration = 0
        let g:jedi#smart_auto_mappings = 0
        if !exists('g:neocomplete#force_omni_input_patterns')
            let g:neocomplete#force_omni_input_patterns = {}
        endif
        let g:neocomplete#force_omni_input_patterns.python =
                    \ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
        " alternative pattern: '\h\w*\|[^. \t]\.\w*'
    else
        " https://github.com/davidhalter/jedi-vim/issues/399#issuecomment-191537503

        au FileType python setlocal completeopt-=longest " The reason to deactivate jedi#auto_vim_configuration

        " https://github.com/davidhalter/jedi-vim/issues/179
        let g:jedi#popup_select_first = 0
        let g:jedi#auto_vim_configuration = 0

        let g:jedi#popup_on_dot = 1
        autocmd FileType python setlocal omnifunc=jedi#completions
    endif

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
