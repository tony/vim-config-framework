" Don't display these kinds of files
let NERDTreeIgnore=['\~$', '\.pyc', '\.swp$', '\.git', '\.hg', '\.svn',
      \ '\.ropeproject', '\.o', '\.bzr', '\.ipynb_checkpoints$',
      \ '__pycache__',
      \ '\.egg$', '\.egg-info$', '\.tox$', '\.idea$', '\.sass-cache',
      \ '\.env$', '\.env[0-9]$', '\.coverage$', '\.tmp$', '\.gitkeep$',
      \ '\.coverage$', '\.webassets-cache$', '\.vagrant$', '\.DS_Store',
      \ '\.env-pypy$', '\.debug.{d,o}$']

let g:vimfiler_ignore_pattern='\%(.ini\|.sys\|.bat\|.BAK\|.DAT\|.pyc\|.egg-info\)$\|'.
  \ '^\%(.gitkeep\|.coverage\|.webassets-cache\|.vagrant\|)$\|'.
  \ '^\%(.env\|.ebextensions\|.elasticbeanstalk\|Procfile\)$\|'.
  \ '^\%(.git\|.tmp\|__pycache__\|.DS_Store\|.o\|.tox\|.idea\|.ropeproject\)$'

set wildignore=*.o,*.obj,*~,*.pyc "stuff to ignore when tab completing
set wildignore+=*.debug.o,*.debug.d
set wildignore+=.env
set wildignore+=.env[0-9]+
set wildignore+=.env-pypy
set wildignore+=.git,.gitkeep
set wildignore+=.tmp
set wildignore+=.coverage
set wildignore+=*DS_Store*
set wildignore+=.sass-cache/
set wildignore+=__pycache__/
set wildignore+=.webassets-cache/
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=.tox/**
set wildignore+=.idea/**
set wildignore+=.vagrant/**
set wildignore+=.coverage/**
set wildignore+=*.egg,*.egg-info
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/Library/**,*/.rbenv/**
set wildignore+=*/.nx/**,*.app

let g:netrw_list_hide='\.o,\.obj,*\~,\.pyc,' "stuff to ignore when tab completing
let g:netrw_list_hide.='\.debug\.d,\.debug\.o,'
let g:netrw_list_hide.='\.env,'
let g:netrw_list_hide.='\.env[0-9].,'
let g:netrw_list_hide.='\.env-pypy,'
let g:netrw_list_hide.='\.git,'
let g:netrw_list_hide.='\.gitkeep,'
let g:netrw_list_hide.='\.vagrant,'
let g:netrw_list_hide.='\.tmp,'
let g:netrw_list_hide.='\.coverage$,'
let g:netrw_list_hide.='\.DS_Store,'
let g:netrw_list_hide.='__pycache__,'
let g:netrw_list_hide.='\.webassets-cache/,'
let g:netrw_list_hide.='\.sass-cache/,'
let g:netrw_list_hide.='\.ropeproject/,'
let g:netrw_list_hide.='vendor/rails/,'
let g:netrw_list_hide.='vendor/cache/,'
let g:netrw_list_hide.='\.gem,'
let g:netrw_list_hide.='\.ropeproject/,'
let g:netrw_list_hide.='\.coverage/,'
let g:netrw_list_hide.='log/,'
let g:netrw_list_hide.='tmp/,'
let g:netrw_list_hide.='\.tox/,'
let g:netrw_list_hide.='\.idea/,'
let g:netrw_list_hide.='\.egg,\.egg-info,'
let g:netrw_list_hide.='\.png,\.jpg,\.gif,'
let g:netrw_list_hide.='\.so,\.swp,\.zip,/\.Trash/,\.pdf,\.dmg,/Library/,/\.rbenv/,'
let g:netrw_list_hide.='*/\.nx/**,*\.app'

try
  " Set up some custom ignores
  call unite#custom#source('buffer,file,file_rec/async,file_rec,file_mru,file,grep',
      \ 'ignore_pattern', join([
      \ '\.DS_Store',
      \ '\.tmp/',
      \ '\.git/',
      \ '\.gitkeep',
      \ '\.hg/',
      \ '\.tox',
      \ '\.idea',
      \ '\.pyc',
      \ '\.png',
      \ '\.gif',
      \ '\.jpg',
      \ '\.svg',
      \ '\.eot',
      \ '\.ttf',
      \ '\.woff',
      \ '\.ico',
      \ '\.o',
      \ '__pycache__',
      \ '.env',
      \ '.env*',
      \ '.vagrant',
      \ '_build',
      \ 'dist',
      \ '*.tar.gz',
      \ '*.zip',
      \ 'node_modules',
      \ 'bower_components',
      \ '.*\.egg',
      \ '*.egg-info',
      \ '.*egg-info.*',
      \ 'git5/.*/review/',
      \ 'google/obj/',
      \ '\.webassets-cache/',
      \ '\.sass-cache/',
      \ '\.coverage/',
      \ '\.m2/',
      \ '\.activator/',
      \ '\.composer/',
      \ '\.cache/',
      \ '\.npm/',
      \ '\.node-gyp/',
      \ '\.sbt/',
      \ '\.ivy2/',
      \ '\.local/activator/',
      \ ], '\|'))
catch
endtry
