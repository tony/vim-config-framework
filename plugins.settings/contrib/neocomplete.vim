function! StartNeocomplete()
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_auto_delimiter = 1
    let g:neocomplete#max_list = 15
    let g:neocomplete#force_overwrite_completefunc = 1

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
          \ 'default' : '',
          \ 'vimshell' : $HOME.'/.vimshell_hist',
          \ 'scheme' : $HOME.'/.gosh_completions'
          \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = ''

    " Plugin key-mappings {
    " These two lines conflict with the default digraph mapping of <C-K>
    if !exists('g:spf13_no_neosnippet_expand')
      imap <C-k> <Plug>(neosnippet_expand_or_jump)
      smap <C-k> <Plug>(neosnippet_expand_or_jump)
    endif
    if exists('g:spf13_noninvasive_completion')
      inoremap <CR> <CR>
      " <ESC> takes you out of insert mode
      inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
      " <CR> accepts first, then sends the <CR>
      inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
      " <Down> and <Up> cycle like <Tab> and <S-Tab>
      inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
      inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
      " Jump up and down the list
      inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
      inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
    else
      " <C-k> Complete Snippet
      " <C-k> Jump to next snippet point
      imap <silent><expr><C-k> neosnippet#expandable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
            \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
      smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

      inoremap <expr><C-g> neocomplete#undo_completion()
      inoremap <expr><C-l> neocomplete#complete_common_string()
      "inoremap <expr><CR> neocomplete#complete_common_string()

      " <CR>: close popup
      " <s-CR>: close popup and save indent.
      inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()."\<CR>" : "\<CR>"

      " <C-h>, <BS>: close popup and delete backword char.
      inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
      inoremap <expr><C-y> neocomplete#smart_close_popup()
    endif
    " <TAB>: completion.
    inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

    " }

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.eruby = '[^. *\t]\.\h\w*\|\h\w*::'
    let g:neocomplete#sources#omni#input_patterns.typescript = '[^. *\t]\.\w*\|\h\w*::'

    if !exists('g:neocomplete#sources#omni#functions')
      let g:neocomplete#sources#omni#functions        = {}
    endif

    let g:neocomplete#sources#omni#functions.ruby='rubycomplete#Complete'
    let g:neocomplete#sources#omni#functions.eruby='rubycomplete#Complete'

    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#force_omni_input_patterns.typescript = '[^. *\t]\.\w*\|\h\w*::'
    let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:neocomplete#force_omni_input_patterns.cpp =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplete#smart_close_popup() . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction

    call neocomplete#custom#source('buffer', 'disabled', 1)
    call neocomplete#custom#source('vim', 'disabled', 1)

    autocmd FileType python setlocal completeopt-=preview

    " Using <C-N> for omnicompletion
    imap <expr> <C-n> neocomplete#start_manual_complete()
    silent! NeoCompleteEnable
endfunction

if !has('nvim')
  call PlugOnLoad('neocomplete.vim', 'call StartNeocomplete()')
endif
