if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source ~/.vimrc
endif

" Automatically install missing plugins on startup
autocmd VimEnter *
      \| if !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)'))
        \|   PlugInstall | q
        \| endif

function! PlugOnLoad(name, exec)
  if !has_key(g:plugs, a:name)
    return
  endif
  if has_key(g:plugs[a:name], 'on') || has_key(g:plugs[a:name], 'for')
    execute 'autocmd! User' a:name a:exec
  else
    execute 'autocmd VimEnter *' a:exec
  endif
endfunction

call plug#begin('~/.vim/plugged')

if !exists('g:bundles')
  for fpath in split(globpath('~/.vim/plugins.d/', '*.vim'), '\n')
    exe 'source' fpath
  endfor
else
  for fpath in g:bundles
    if filereadable(expand(fpath))
      exe 'source' expand(fpath)
    endif
  endfor
endif


call plug#end()
