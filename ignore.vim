" Don't display these kinds of files
let NERDTreeIgnore=['\~$', '\.pyc', '\.swp$', '\.git', '\.hg', '\.svn',
      \ '\.ropeproject', '\.o', '\.bzr', '\.ipynb_checkpoints', '__pycache__',
      \ '\.egg$', '\.egg-info$']

let g:vimfiler_ignore_pattern='\%(.ini\|.sys\|.bat\|.BAK\|.DAT\|.pyc\|.egg-info\)$\|'.
  \ '^\%(.git\|__pycache__\|.DS_Store\|.o\|.ropeproject\)$'

set wildignore=*.o,*.obj,*~,*.pyc "stuff to ignore when tab completing
set wildignore+=*DS_Store*
set wildignore+=__pycache__
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.egg,*.egg-info
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/Library/**,*/.rbenv/**
set wildignore+=*/.nx/**,*.app

let g:netrw_list_hide='\.o$,\.obj$,*~,\.pyc$,' "stuff to ignore when tab completing
let g:netrw_list_hide.='\.DS_Store$,'
let g:netrw_list_hide.='__pycache__,'
let g:netrw_list_hide.='\.ropeproject/$,'
let g:netrw_list_hide.='vendor/rails/,'
let g:netrw_list_hide.='vendor/cache/,'
let g:netrw_list_hide.='\.gem$,'
let g:netrw_list_hide.='\.ropeproject/$,'
let g:netrw_list_hide.='log/,'
let g:netrw_list_hide.='tmp/,'
let g:netrw_list_hide.='\.egg,\.egg-info,'
let g:netrw_list_hide.='\.png$,\.jpg$,\.gif$,'
let g:netrw_list_hide.='\.so$,\.swp$,\.zip$,/\.Trash/,\.pdf$,\.dmg$,/Library/,/\.rbenv/,'
let g:netrw_list_hide.='*/\.nx/**,*\.app'

if has('unite.vim')

  " Set up some custom ignores
  call unite#custom#source('buffer,file,file_rec/async,file_rec,file_mru,file,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ '\.hg/',
      \ '\.pyc',
      \ '\.o',
      \ '__pycache__',
      \ '.env*',
      \ '_build',
      \ 'dist',
      \ '*.tar.gz',
      \ '*.zip',
      \ 'node_modules',
      \ '*.egg-info',
      \ '.*egg-info.*',
      \ 'git5/.*/review/',
      \ 'google/obj/',
      \ ], '\|'))
endif
