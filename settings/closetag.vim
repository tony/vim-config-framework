if neobundle#tap('closetag')
  function! neobundle#hooks.on_post_source(bundle)
    let g:closetag_default_xml=1

    autocmd FileType html,htmldjango,jinja.html,eruby,mako let b:closetag_html_style=1
    autocmd FileType html,xhtml,xml,htmldjango,jinja.html,eruby,mako source ~/.vim/bundle/closetag.vim/plugin/closetag.vim
  endfunction

  call neobundle#untap()
endif
