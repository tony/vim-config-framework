function StartDeoplete()
    " deoplete.vim
    " credit: https://gist.github.com/zchee/c314e63ae8b6bea50bb4
    let g:deoplete#enable_at_startup = 1
    set completeopt+=noinsert
    set completeopt-=preview
    let g:deoplete#enable_ignore_case = 1
    let g:deoplete#auto_completion_start_length = 0

    let g:deoplete#ignore_sources = {}
    let g:deoplete#ignore_sources._ = ['buffer', 'vim', 'member']
    let g:deoplete#sources#go = 'vim-go'
    let g:deoplete#disable_auto_complete = 1

    " From https://github.com/Shougo/shougo-s-github/blob/4dea47c/vim/rc/plugins/deoplete.rc.vim
    " Accessed  2018-04-01
    let g:deoplete#enable_refresh_always = 0
    let g:deoplete#skip_chars = ['(', ')']

    " <S-TAB>: completion back.
    inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ deoplete#manual_complete()
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    call deoplete#custom#source('_', 'converters', [
          \ 'converter_remove_paren',
          \ 'converter_remove_overlap',
          \ 'converter_truncate_abbr',
          \ 'converter_truncate_menu',
          \ 'converter_auto_delimiter',
          \ ])

    let g:deoplete#keyword_patterns = {}
    let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'

    let g:deoplete#omni#input_patterns = {}
    let g:deoplete#omni#input_patterns.javascript = '[^. *\t]\.\w*'
    let g:deoplete#omni#input_patterns.python = ''

    inoremap <expr><C-n> deoplete#mappings#manual_complete()
endfunction

call PlugOnLoad('deoplete.nvim', 'call StartDeoplete()')
