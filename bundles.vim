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
  for fpath in split(globpath('~/.vim/settings/', '*.vim'), '\n')
    exe 'source' fpath
  endfor
else
  for fpath in g:bundles
    if filereadable(expand(fpath))
      exe 'source' expand(fpath)
    endif
  endfor
endif





NeoBundleLazy 'justmao945/vim-clang', {
      \ 'autoload': {
      \  'filetypes':['c', 'cpp'],
      \  'external_commands' : ['clang'],
      \ }
      \}


NeoBundleLazy 'Shougo/neocomplete.vim', { 'autoload' : { 'insert' : '1' }, 'disabled' : (!has('lua')) }

NeoBundleLazy 'Shougo/context_filetype.vim', { 'autoload' : { 'function_prefix' : 'context_filetype' } }


NeoBundleLazy 'honza/vim-snippets', { 'autoload': { 'on_source': 'ultisnips' } }
NeoBundle 'SirVer/ultisnips'


NeoBundleLazy 'jalcine/cmake.vim', {
      \ 'autoload': {
      \   'commands': [
      \     'CMakeBuild',
      \     'CMakeCeateClean',
      \     'CMakeClean'
      \   ],
      \  'filetypes':['c', 'cpp'],
      \  'external_commands' : ['cmake'],
      \ }
      \}


NeoBundleLazy 'jeaye/color_coded', { 
      \ 'build': {
      \   'unix': 'cmake . && make && make install',
      \   'linux': 'cmake . -DCUSTOM_CLANG=1 -DLLVM_ROOT_PATH=/usr -DLLVM_INCLUDE_PATH=/usr/lib/llvm-3.4/include'
      \ },
      \ 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] },
      \ 'build_commands' : ['cmake', 'make']
      \}

NeoBundleLazy 'rhysd/vim-clang-format',
      \ { 'autoload' : { 'filetypes' : ['c', 'cpp', 'objc', 'objcpp'] } }


" Colors {{{
" ==========

NeoBundle 'tomasr/molokai'
NeoBundle 'chriskempson/base16-vim'

" Fork of NeoBundle "kien/rainbow_parentheses.vim"
NeoBundle "luochen1990/rainbow" 

if executable('ag')
  NeoBundleLazy 'rking/ag.vim', {
        \ 'autoload': {
        \   'commands': ['Ag', 'grep'],
        \ },
        \ 'external_command': 'ag',
        \ }
endif

" Configuration {{{
" =================

" Disable plugins for LargeFile
NeoBundleLazy 'vim-scripts/LargeFile'

" }}}


" Browse {{{
" ==========

" A tree explorer plugin for vim.
NeoBundleLazy 'scrooloose/nerdtree', { 
      \ 'autoload' : {
      \    'commands': ['NERDTreeToggle', 'NERDTree', 'NERDTreeClose']
      \  }
      \} 
NeoBundleLazy 'Xuyuanp/git-nerdtree', {
      \   "autoload" : {
      \       "commands" : ["NERDTreeToggle", "NERDTree", "NERDTreeClose"]
      \   }
      \}

" Vim plugin that displays tags in a window, ordered by class etc.
NeoBundle "majutsushi/tagbar", {
      \ 'lazy': 1,
      \ 'autoload' : {'commands': 'TagbarToggle'}
      \} 

" }}}



" Status line {{{
" ===============

" lean & mean statusline for vim that's light as air
NeoBundleLazy 'bling/vim-airline'

" }}}

" todo move to settings
let g:tagbar_type_javascript = {
      \ 'ctagsbin': expand('~/.vim/bundle/jsctags/bin/jsctags')
      \ }

let g:tagbar_type_rst = {
      \ 'ctagstype': 'rst',
      \ 'kinds': [ 'r:references', 'h:headers' ],
      \ 'sort': 0,
      \ 'sro': '..',
      \ 'kind2scope': { 'h': 'header' },
      \ 'scope2kind': { 'header': 'h' }
      \ }




NeoBundleLazy 'othree/html5-syntax.vim', {
      \ 'autoload' : {
      \     'filetypes' : ['html', 'xhtml', 'jst', 'ejs']
      \   }
      \ }


NeoBundleLazy 'groenewege/vim-less', {
      \ 'autoload' : {
      \   'filetypes' : 'less',
      \ }
      \ }

" causes rst files to load slow...
" NeoBundleLazy 'skammer/vim-css-color', {
" \ 'autoload' : {
" \   'filetypes' : ['css', 'less']
" \ }}

NeoBundleLazy 'hail2u/vim-css3-syntax', {
      \ 'autoload' : {
      \   'filetypes' : ['css', 'less'],
      \ }}
NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', {'autoload':{'filetypes':['cpp']}}
NeoBundleLazy 'tpope/vim-markdown', {'autoload':{'filetypes':['markdown']}}
NeoBundleLazy 'nelstrom/vim-markdown-folding', {'autoload':{'filetypes':['markdown']}}

" }}}  


" Syntax checkers {{{
" ===================
NeoBundleLazy 'scrooloose/syntastic', {
      \ 'autoload': {
      \   'insert': 1,
      \ }
      \ }
" }}}




" features
NeoBundleLazy 'nathanaelkane/vim-indent-guides' " color indentation

if has('conceal')
  NeoBundleLazy 'Yggdroot/indentLine'
endif


" NeoBundleLazy 'thinca/vim-quickrun'

" NeoBundleLazy 'scrooloose/nerdcommenter'
NeoBundle 'tomtom/tcomment_vim', {
      \ 'autoload' : {
      \   'commands' : [
      \     'TComment', 'TCommentAs', 'TCommentRight',
      \      'TCommentBlock', 'TCommentInline', 'TCommentMaybeInline',
      \ ]}}

NeoBundleLazy 'Rykka/riv.vim', {
      \ 'filetypes' : ['rst', 'python'],
      \ }
" https://github.com/Rykka/riv.vim/issues/42

" :Move, :SudoWrite, :Chmod, :Mkdir
NeoBundleLazy 'tpope/vim-eunuch', {
      \ 'autoload': {
      \   'commands': [
      \     'Unlink',
      \     'Remove',
      \     'Move',
      \     'Rename',
      \     'Chmod',
      \     'Mkdir',
      \     'Find',
      \     'Locate',
      \     'SudoEdit',
      \     'SudoWrite',
      \     'W'
      \   ]
      \ }
      \}
NeoBundleLazy 'tpope/vim-dispatch', {
      \ 'autoload': {
      \   'commands': [
      \     'Make',
      \     'Start',
      \     'Copen',
      \     'Dispatch',
      \     'FocusDispatch'
      \   ]
      \ }
      \}

if executable('java')
  NeoBundleLazy 'tpope/vim-classpath', {
        \ 'autoload': {
        \   'filetypes': ['java', 'clojure']
        \ }
        \}
endif
NeoBundleLazy 'justinmk/vim-syntax-extra'

NeoBundleLazy 'Lokaltog/vim-easymotion'


NeoBundle 'vim-scripts/bufkill.vim'
NeoBundle 'editorconfig/editorconfig-vim', {
      \ }

if executable('git')

  NeoBundleLazy 'airblade/vim-gitgutter'
  NeoBundle 'tpope/vim-fugitive', {
        \ 'autoload' : {'commands': 
        \   ['Gwrite', 'Gcommit', 'Gmove', 'Ggrep', 'Gbrowse', 'Glog',
        \    'Git', 'Gedit', 'Gsplit', 'Gvsplit', 'Gtabedit', 'Gdiff',
        \    'Gstatus', 'Gblame'],
        \ }}

  NeoBundleLazy 'gregsexton/gitv', {
        \ 'autoload': {
        \   'commands': 'Gitv'
        \ }
        \}
endif
"
" Unite
"
" Fuzzy Search
NeoBundleLazy 'Shougo/neomru.vim'

" NeoBundleLazy 'Shougo/unite.vim', { 'name' : 'unite.vim'
"       \ , 'depends' : 'vimproc'
"       \ }
"
"
" NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : { 'unite_sources' : ['history/command', 'history/search']}}
" NeoBundleLazy 'osyo-manga/unite-quickfix', {'autoload':{'unite_sources': ['quickfix', 'location_list']}}
"
" NeoBundleLazy 'Shougo/unite-help', { 'depends' : 'unite.vim'
"       \ , 'autoload' : { 'unite_sources' : 'help' }
"       \ }
" NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}}
"
" NeoBundleLazy 'Shougo/unite-session', {'autoload':{'unite_sources':'session', 'commands': ['UniteSessionSave', 'UniteSessionLoad']}}
" NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload':{'unite_sources': 'colorscheme'}}

NeoBundleLazy 'facebook/vim-flow', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

"
"" haskell
"
if executable('ghc-mod')
  NeoBundleLazy 'dag/vim2hs', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}


  NeoBundleLazy 'eagletmt/ghcmod-vim', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}

  NeoBundleLazy 'ujihisa/neco-ghc', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}

  NeoBundleLazy 'Twinside/vim-hoogle', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}

  NeoBundleLazy 'carlohamalainen/ghcimportedfrom-vim', {
        \ 'autoload' : {
        \   'filetypes' : 'haskell',
        \ }}
endif


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
