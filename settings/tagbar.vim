if neobundle#tap('tagbar')
  function! neobundle#hooks.on_post_source(bundle)


    let g:tagbar_width = 30
    let g:tagbar_foldlevel = 1

    " Toggle tagbar
    nnoremap <silent> <F3> :TagbarToggle<CR>


    " todo move to settings
    let g:tagbar_type_javascript = {
          \ 'ctagsbin': expand('~/.vim/bundle/jsctags/bin/jsctags')
          \ }


    " https://github.com/tony/.dot-config/blob/19ee6e73c419989d26bb3a78f4d3abbdccc3f658/.ctags#L12
    " Old version of rst tags
    " let g:tagbar_type_rst = {
    "       \ 'ctagstype': 'rst',
    "       \ 'kinds': [ 'r:references', 'h:headers' ],
    "       \ 'sort': 0,
    "       \ 'sro': '..',
    "       \ 'kind2scope': { 'h': 'header' },
    "       \ 'scope2kind': { 'header': 'h' }
    "       \ }
    let g:tagbar_type_rst = {
          \ 'ctagstype': 'rst',
          \ 'ctagsbin': expand('~/.vim/bundle/rst2ctags/rst2ctags.py'),
          \ 'ctagsargs' : '-f - --sort=yes',
          \ 'kinds' : [
          \ 's:sections',
          \ 'i:images'
          \ ],
          \ 'sro' : '|',
          \ 'kind2scope' : {
          \ 's' : 'section',
          \ },
          \ 'sort': 0,
          \ }
  endfunction

  call neobundle#untap()
endif
