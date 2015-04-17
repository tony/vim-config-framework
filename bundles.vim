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



NeoBundle 'airblade/vim-rooter'

let ycm_build_options = './install.sh'

if executable('cmake')
  let ycm_build_options .= ' --clang-completer --system-libclang --system-boost'
endif

if executable('go')
  let ycm_build_options .= ' --gocode-completer'
endif

NeoBundleLazy 'Valloric/YouCompleteMe',  
      \ {
      \ 'autoload': {'filetypes':['c', 'cpp', 'python', 'objcpp', 'go']}, 
      \ 'disabled': (!has('python')),
      \ 'insert': 1,
      \ 'augroup': 'youcompletemeStart',
      \ 'build_commands' : ['cmake', 'make'],
      \ 'build': {
      \   'unix': g:ycm_build_options,
      \ },
      \ }

NeoBundleLazy 'jeaye/color_coded', { 
      \ 'build': {
      \   'unix': 'cmake . && make && make install',
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

if executable('ruby')
  NeoBundleLazy 'vim-ruby/vim-ruby', {
        \ 'autoload' : {
        \   'filetypes' : 'ruby',
        \ }}
  NeoBundleLazy 'tpope/rbenv-ctags', {
        \ 'autoload' : {
        \   'filetypes' : 'ruby',
        \ }}
  NeoBundleLazy 'tpope/vim-rbenv', {
        \ 'autoload' : {
        \   'filetypes' : 'ruby',
        \ }}
endif

" endwise.vim: wisely add "end" in ruby, endfunction/endif/more in vim script, etc
NeoBundleLazy 'tpope/vim-endwise'

NeoBundleLazy 'tpope/vim-surround'

" NeoBundleLazy 'terryma/vim-multiple-cursors'
NeoBundleLazy 'tony/vim-multiple-cursors', { 'rev': 'quit-multiple-cursors' }


" Utils {{{
" =========
NeoBundleLazy 'vim-scripts/closetag.vim'  "  messes up python docstrings		
" }}}

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
      \ 'autoload' : {'commands': ['NERDTreeToggle', 'NERDTree', 'NERDTreeClose']}} 
NeoBundleLazy 'Xuyuanp/git-nerdtree', {
\   "autoload" : {
\       "commands" : ["NERDTreeToggle", "NERDTree", "NERDTreeClose"]
\   }
\}

" NeoBundleLazy 'Shougo/vimfiler'

" Find files
" NeoBundleLazy 'kien/ctrlp.vim'
NeoBundleLazy 'ctrlpvim/ctrlp.vim', 
  \ {'autoload': {'commands': ['CtrlP', 'CtrlPBuffer', 'CtrlPMRU', 'CtrlPLastMode', 'CtrlPRoot', 'CtrlPClearCache', 'CtrlPClearAllCaches']}}
NeoBundleLazy 'tacahiroy/ctrlp-funky',
  \ {'autoload': {'commands': ['CtrlPFunky']}}
NeoBundle 'FelikZ/ctrlp-py-matcher', {
  \   'depends' : 'ctrlpvim/ctrlp.vim'
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


" Motion and operators {{{
" ========================

" }}}  



" Languages {{{
" =============
NeoBundleLazy 'klen/python-mode', {
      \ 'autoload' : {
      \   'filetypes' : 'python',
      \ }}

NeoBundleLazy 'google/yapf', {
      \ 'autoload' : {
      \   'filetypes' : 'python',
      \ },
      \ 'build': {
      \   'unix': 'pip install --user -e .',
      \ },
      \ 'rtd': "~/.vim/bundle/yapf/plugins",
      \ 'script_type': 'plugin'
  \ }


" NeoBundleLazy 'ehamberg/vim-cute-python', 'moresymbols', {
"     \ 'autoload': {
"     \   'filetypes': 'python',
"     \ },
"     \ 'disabled': !has('conceal'),
" \ }

NeoBundleLazy 'tell-k/vim-autopep8', {
      \ 'autoload' : {
      \   'filetypes' : 'python',
      \ }}

NeoBundleLazy 'PotatoesMaster/i3-vim-syntax', {
      \ 'autoload' : {
      \   'filetypes' : 'i3',
      \ }}

if executable('php')
  NeoBundleLazy 'm2mdas/phpcomplete-extended'
  "NeoBundleLazy 'dsawardekar/wordpress.vim'
  "NeoBundleLazy 'shawncplus/phpcomplete.vim'
  NeoBundleLazy 'StanAngeloff/php.vim'
  " NeoBundleLazy 'm2mdas/phpcomplete-extended-laravel'
endif

NeoBundleLazy 'Shutnik/jshint2.vim'

NeoBundleLazy 'ekalinin/Dockerfile.vim',
      \ {'autoload': {'filetypes': 'Dockerfile'}}
" NeoBundleLazy 'aaronj1335/underscore-templates.vim'
NeoBundleLazy 'saltstack/salt-vim'
NeoBundle "Glench/Vim-Jinja2-Syntax"
NeoBundle "Vim-scripts/django.vim"
NeoBundle "briancollins/vim-jst"
NeoBundleLazy "mklabs/grunt", {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}
NeoBundleLazy 'xolox/vim-lua-ftplugin' , {
      \ 'autoload' : {'filetypes' : 'lua'},
      \ 'depends' : 'xolox/vim-misc',
      \ }

NeoBundleLazy 'elzr/vim-json', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}
" indent yaml
NeoBundleLazy 'avakhov/vim-yaml', {
      \ 'autoload' : {
      \   'filetypes' : 'python',
      \ }}

NeoBundleLazy 'xsbeats/vim-blade', {
      \ 'autoload' : { 'filetypes' : ['blade'] }}


NeoBundleLazy 'mklabs/vim-backbone', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

NeoBundleLazy 'mxw/vim-jsx', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

NeoBundleLazy 'pangloss/vim-javascript', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}

if executable('node')
  NeoBundleLazy 'maksimr/vim-jsbeautify', {
        \ 'autoload' : {
        \   'filetypes' : ['javascript', 'html', 'mustache', 'css', 'less', 'jst']
        \ }}


  NeoBundleFetch 'einars/js-beautify' , {
        \   'build' : {
        \       'unix' : 'npm install --update',
        \   },
        \}

  " NeoBundleFetch 'ramitos/jsctags.git', { 'build': {
  "     \   'windows': 'npm install',
  "     \   'cygwin': 'npm install',
  "     \   'mac': 'npm install',
  "     \   'unix': 'npm install --update',
  "     \ }
  " \ }
  NeoBundleLazy 'marijnh/tern_for_vim', { 'build': {
        \   'windows': 'npm install',
        \   'cygwin': 'npm install',
        \   'mac': 'npm install',
        \   'unix': 'npm install',
        \ },
        \ 'autoload' : {
        \   'filetypes' : 'javascript',
        \ }
        \ }

endif

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


if executable('latex')
  NeoBundleLazy 'LaTeX-Box-Team/LaTeX-Box', { 'autoload' :
        \   { 'filetypes' : [ 'tex'
        \ , 'latex'
        \ ]
        \   }
        \ }
endif

" NeoBundleLazy 'bbommarito/vim-slim'
NeoBundleLazy 'slim-template/vim-slim'
NeoBundleLazy 'wavded/vim-stylus'

NeoBundleLazy 'othree/html5-syntax.vim', {
      \ 'autoload' : {
      \     'filetypes' : ['html', 'xhtml', 'jst', 'ejs']
      \   }
      \ }

NeoBundleLazy 'mustache/vim-mustache-handlebars', {
      \ 'autoload' : {
      \   'filetypes': ['html', 'mustache', 'hbs']
      \ }}
if executable('go')
  " Disable, use ycm's gocode completer
  NeoBundleLazy "fatih/vim-go", {
        \ 'autoload': {'filetypes': ['go']}}
  NeoBundleLazy "jstemmer/gotags", {
        \ 'autoload': {'filetypes': ['go']}}
endif

" NeoBundleLazy 'vim-scripts/VimClojure'
if executable('scala')
  NeoBundleLazy 'derekwyatt/vim-scala', {
        \ 'autoload': {
        \   'filetypes': 'scala'
        \ }
        \}
  NeoBundleLazy 'gre/play2vim'
endif
" NeoBundleLazy 'elixir-lang/vim-elixir'
"NeoBundleLazy 'evanmiller/nginx-vim-syntax'
if executable('nginx')
  NeoBundleLazy 'evanmiller/nginx-vim-syntax', {'autoload': {'filetypes': 'nginx'}}
endif
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
NeoBundleLazy 'kchmck/vim-coffee-script', {'autoload':{'filetypes':['coffee', 'haml']}}
NeoBundleLazy 'othree/javascript-libraries-syntax.vim', {'autoload':{'filetypes':['javascript','coffee','ls','ty']}}
NeoBundleLazy 'octol/vim-cpp-enhanced-highlight', {'autoload':{'filetypes':['cpp']}}
NeoBundleLazy 'tpope/vim-haml', {
      \ 'autoload': {
      \   'filetypes': 'haml'
      \ }
      \}
NeoBundleLazy 'tpope/vim-markdown', {'autoload':{'filetypes':['markdown']}}
NeoBundleLazy 'nelstrom/vim-markdown-folding', {'autoload':{'filetypes':['markdown']}}
NeoBundleLazy 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}}
NeoBundleLazy 'markcornick/vim-vagrant'

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
NeoBundleLazy 'tpope/vim-classpath', {
      \ 'autoload': {
      \   'filetypes': ['java', 'clojure']
      \ }
      \}
NeoBundleLazy 'justinmk/vim-syntax-extra'

" motion
NeoBundleLazy 'Lokaltog/vim-easymotion'


NeoBundle 'vim-scripts/bufkill.vim'
NeoBundleLazy 'editorconfig/editorconfig-vim', {
    \ 'autoload': {
    \   'insert': 1,
    \ }
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

NeoBundleLazy 'Shougo/unite.vim', { 'name' : 'unite.vim'
      \ , 'depends' : 'vimproc'
      \ }


NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : { 'unite_sources' : ['history/command', 'history/search']}}
NeoBundleLazy 'osyo-manga/unite-quickfix', {'autoload':{'unite_sources': ['quickfix', 'location_list']}}

NeoBundleLazy 'Shougo/unite-help', { 'depends' : 'unite.vim'
      \ , 'autoload' : { 'unite_sources' : 'help' }
      \ }
NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}}

NeoBundleLazy 'Shougo/unite-session', {'autoload':{'unite_sources':'session', 'commands': ['UniteSessionSave', 'UniteSessionLoad']}}
NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload':{'unite_sources': 'colorscheme'}}

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


NeoBundleLazy 'honza/vim-snippets', { 'autoload': { 'on_source': 'ultisnips' } }
NeoBundle 'SirVer/ultisnips'
NeoBundle 'ervandew/supertab'

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
