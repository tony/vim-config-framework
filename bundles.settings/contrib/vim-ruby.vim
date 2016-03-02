function! StartVimRuby()
    " no implicit conversion from nil to integer, switch to 0
    let g:rubycomplete_rails = 0
    let g:rubycomplete_load_gemfile = 1
    let g:rubycomplete_use_bundler = 1
    let g:ruby_fold = 1
    let g:ruby_space_errors = 1
    let g:ruby_operators = 1
    let g:ruby_no_expensive = 1

    let g:rubycomplete_buffer_loading = 1
    let g:rubycomplete_classes_in_global = 1

endfunction

autocmd! User vim-ruby call StartVimRuby()
