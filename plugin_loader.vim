if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

function! plugin_loader#PlugOnLoad(name, exec)
  if !has_key(g:plugs, a:name)
    return
  endif
  if has_key(g:plugs[a:name], 'on') || has_key(g:plugs[a:name], 'for')
    execute 'autocmd! User' a:name a:exec
  else
    execute 'autocmd VimEnter *' a:exec
  endif
endfunction


function! plugin_loader#PlugInit()
  call plug#begin('~/.vim/plugged')

  " Automatically install missing plugins on startup
  " https://github.com/junegunn/vim-plug/issues/212#issuecomment-92159417
  if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
    autocmd VimEnter * PlugInstall | q
  endif

  if !exists('g:bundles')
    for fpath in split(globpath('~/.vim/plugins.d/', '*.vim'), '\n')
      exe 'source' fpath
    endfor

    if filereadable(expand('~/.vim/plugins.vim'))
      exe 'source' expand('~/.vim/plugins.vim')
    endif
  else
    for fpath in g:bundles
      if filereadable(expand(fpath))
        exe 'source' expand(fpath)
      endif
    endfor
  endif

  call plug#end()
endfunction
