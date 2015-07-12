" bundles.vim credit: https://github.com/klen/.vim/blob/master/bundle.vim

set nocompatible
filetype off

" Setting up Vundle - the vim plugin bundler
" Credit:  http://www.erikzaadi.com/2012/03/19/auto-installing-vundle-from-your-vimrc/
let iCanHazNeoBundle=1
let neobundle_readme=expand('~/.vim/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
  echo "Installing neobundle.vim."
  echo ""
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
  let iCanHazNeoBundle=0
endif

set rtp+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))


" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile

let g:make = 'gmake'
if system('uname -o') =~ '^GNU/'
  let g:make = 'make'
endif

NeoBundle 'Shougo/vimproc', { 'build': {
      \   'windows' : 'tools\\update-dll-mingw',
      \   'cygwin': 'make -f make_cygwin.mak',
      \   'mac': 'make -f make_mac.mak',
      \   'unix': g:make,
      \ } }



if !exists('g:bundles')
  for fpath in split(globpath('~/.vim/bundles.d/', '*.vim'), '\n')
    exe 'source' fpath
  endfor
else
  for fpath in g:bundles
    if filereadable(expand(fpath))
      exe 'source' expand(fpath)
    endif
  endfor
endif

" Disable plugins for LargeFile
NeoBundleLazy 'vim-scripts/LargeFile'

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

NeoBundleFetch 'jszakmeister/rst2ctags'

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

NeoBundle 'vim-scripts/bufkill.vim'

NeoBundle 'takac/vim-hardtime'

if iCanHazNeoBundle == 0
  echo "Installing Bundles, please ignore key map error messages"
  echo ""
  :NeoBundleInstall
endif
" Setting up Vundle - the vim plugin bundler end

call neobundle#end()


" Needed for Syntax Highlighting and stuff
filetype plugin indent on
syntax enable

" Installation check.
NeoBundleCheck
