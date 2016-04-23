function! StartClosetag()
    let g:closetag_default_xml=1

    autocmd FileType html,htmldjango,jinja.html,eruby,mako let b:closetag_html_style=1
    autocmd FileType html,xhtml,xml,htmldjango,jinja.html,eruby,mako source ~/.vim/bundle/closetag.vim/plugin/closetag.vim
endfunction

call PlugOnLoad('closetag', 'call StartClosetag()')
