function! StartTagbar()
    let g:tagbar_width = 30
    let g:tagbar_foldlevel = 1

    " Toggle tagbar
    nnoremap <silent> <F3> :TagbarToggle<CR>

    " There's no need for this, tagbar automatically will find
    " jsctags
    " let g:tagbar_type_javascript = {
    "       \ 'ctagsbin': expand('~/.vim/bundle/jsctags/bin/jsctags'),
    "       \ }


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

    let g:tagbar_type_go = {
          \ 'ctagstype' : 'go',
          \ 'kinds'     : [
          \ 'p:package',
          \ 'i:imports:1',
          \ 'c:constants',
          \ 'v:variables',
          \ 't:types',
          \ 'n:interfaces',
          \ 'w:fields',
          \ 'e:embedded',
          \ 'm:methods',
          \ 'r:constructor',
          \ 'f:functions'
          \ ],
          \ 'sro' : '.',
          \ 'kind2scope' : {
          \ 't' : 'ctype',
          \ 'n' : 'ntype'
          \ },
          \ 'scope2kind' : {
          \ 'ctype' : 't',
          \ 'ntype' : 'n'
          \ },
          \ 'ctagsbin'  : 'gotags',
          \ 'ctagsargs' : '-sort -silent'
          \ }
endfunction

call PlugOnLoad('tagbar', 'call StartTagbar()')
