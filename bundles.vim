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
NeoBundle 'Shougo/vimproc', { 'build': {
      \   'windows': 'make -f make_mingw32.mak',
      \   'cygwin': 'make -f make_cygwin.mak',
      \   'mac': 'make -f make_mac.mak',
      \   'unix': 'make -f make_unix.mak',
      \ } }


" NeoBundle 'airblade/vim-rooter'

NeoBundle 'Valloric/YouCompleteMe'

let g:ycm_register_as_syntastic_checker = 1
let g:ycm_cache_omnifunc = 0
set completeopt-=preview
"NeoBundle 'jmcantrell/vim-virtualenv'
"let g:virtualenv_auto_activate = 1


NeoBundleLazy 'vim-scripts/closetag.vim'  "  messes up python docstrings


" Fuzzy Search
NeoBundle 'Shougo/neomru.vim'

NeoBundle 'Shougo/unite.vim', { 'name' : 'unite.vim'
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


" Colors {{{
" ==========

    " NeoBundleLazy 'jpo/vim-railscasts-theme'
    NeoBundleLazy 'altercation/vim-colors-solarized'
    NeoBundleLazy 'mbbill/desertEx'
    NeoBundle 'tomasr/molokai'
    NeoBundle 'chriskempson/base16-vim'
    NeoBundleLazy 'nanotech/jellybeans.vim'
    " Fork of NeoBundle "kien/rainbow_parentheses.vim"
    NeoBundle "amdt/vim-niji"
    " auto rainbow {
    nnoremap <leader>r :RainbowParenthesesToggleAll<cr>
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
" }}}



" endwise.vim: wisely add "end" in ruby, endfunction/endif/more in vim script, etc
NeoBundle 'tpope/vim-endwise'


" Utils {{{
" =========

" }}}

" Configuration {{{
" =================

    " Disable plugins for LargeFile
    NeoBundle 'vim-scripts/LargeFile'

" }}}


" Browse {{{
" ==========

    " A tree explorer plugin for vim.
    NeoBundle 'scrooloose/nerdtree', { 
        \ 'lazy': 1,
        \ 'autoload' : {'commands': 'NERDTreeToggle'}} 
    " NeoBundle 'Shougo/vimfiler'

    " Find files
    NeoBundle 'kien/ctrlp.vim'
    NeoBundle 'tacahiroy/ctrlp-funky'
    NeoBundle 'FelikZ/ctrlp-py-matcher'

    let g:ctrlp_extensions = ['funky']

     " PyMatcher for CtrlP
    if !has('python')
        echo 'In order to use pymatcher plugin, you need +python compiled vim'
    else
        let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
    endif

    let g:ctrlp_dont_split = 'NERD_tree_2'
    if executable("ag")
      let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'
      let g:ctrlp_use_caching = 0
    endif

    " Vim plugin that displays tags in a window, ordered by class etc.
    NeoBundle "majutsushi/tagbar", {
        \ 'lazy': 1,
        \ 'autoload' : {'commands': 'TagbarToggle'}} 

    let g:tagbar_width = 30
    let g:tagbar_foldlevel = 1
    let g:tagbar_type_rst = {
        \ 'ctagstype': 'rst',
        \ 'kinds': [ 'r:references', 'h:headers' ],
        \ 'sort': 0,
        \ 'sro': '..',
        \ 'kind2scope': { 'h': 'header' },
        \ 'scope2kind': { 'header': 'h' }
    \ }

    " Toggle tagbar
    nnoremap <silent> <F3> :TagbarToggle<CR>

" }}}



" Status line {{{
" ===============

    " lean & mean statusline for vim that's light as air
    NeoBundle 'bling/vim-airline'

    let g:airline_detect_iminsert = 1

    " Airline theme settings
    let g:airline_powerline_fonts = 1
    "Show buffer list
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#show_buffers = 1
    let g:airline#extensions#tabline#buffer_nr_show = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
    let g:airline#extensions#tabline#buffer_min_count = 2
    "Show whitespace errors
    let g:airline#extensions#whitespace#enabled = 1
    " Tmux
    let g:airline#extensions#tmuxline#enabled = 1
    "let g:airline#extensions#tmuxline#snapshot_file = "~/environment/tmux/statusline-colors.conf"
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

    NeoBundleLazy 'PotatoesMaster/i3-vim-syntax', {
          \ 'autoload' : {
          \   'filetypes' : 'i3',
          \ }}

    if executable('php')
      NeoBundle 'm2mdas/phpcomplete-extended'
      NeoBundle 'StanAngeloff/php.vim'
      NeoBundle 'm2mdas/phpcomplete-extended-laravel'
    endif

    NeoBundle 'Shutnik/jshint2.vim'

    NeoBundleLazy 'ekalinin/Dockerfile.vim',
        \ {'autoload': {'filetypes': 'Dockerfile'}}
    " NeoBundleLazy 'aaronj1335/underscore-templates.vim'
    NeoBundle 'saltstack/salt-vim'
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

    " NeoBundleLazy 'mxw/vim-jsx', {
    "       \ 'autoload' : {
    "       \   'filetypes' : 'javascript',
    "       \ }}

    NeoBundleLazy 'pangloss/vim-javascript', {
          \ 'autoload' : {
          \   'filetypes' : 'javascript',
          \ }}

    " NeoBundleLazy 'maksimr/vim-jsbeautify', {
    "       \ 'autoload' : {
    "       \   'filetypes' : ['javascript', 'html', 'mustache', 'css', 'less', 'jst']
    "       \ }}
    "
    " NeoBundleFetch 'einars/js-beautify' , {
    "       \   'build' : {
    "       \       'unix' : 'npm install --update',
    "       \   },
    "       \}
    "
    " NeoBundleFetch 'ramitos/jsctags.git', { 'build': {
    "     \   'windows': 'npm install',
    "     \   'cygwin': 'npm install',
    "     \   'mac': 'npm install',
    "     \   'unix': 'npm install --update',
    "     \ }
    " \ }
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

    " NeoBundle 'marijnh/tern_for_vim', { 'build': {
    "       \   'windows': 'npm install',
    "       \   'cygwin': 'npm install',
    "       \   'mac': 'npm install',
    "       \   'unix': 'npm install',
    "       \ },
    " \ }

    NeoBundleLazy 'LaTeX-Box-Team/LaTeX-Box', { 'autoload' :
        \   { 'filetypes' : [ 'tex'
                          \ , 'latex'
                          \ ]
        \   }
        \ }


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

    " NeoBundleLazy 'jnwhiteh/vim-golang'
        NeoBundle "fatih/vim-go", {
            \ 'lazy': 1,
            \ 'autoload': {'filetypes': ['go']}}
        au BufNewFile,BufRead *.go set ft=go nu
        au FileType go nnoremap <buffer><leader>r :GoRun<CR>
        au FileType go nnoremap <buffer><C-c>d :GoDef<CR>
        au FileType go setlocal tabstop=4
        au FileType go setlocal softtabstop=4
        let g:go_disable_autoinstall = 1
    " NeoBundleLazy 'vim-scripts/VimClojure'
    NeoBundle 'derekwyatt/vim-scala'
    NeoBundle 'gre/play2vim'
    " NeoBundleLazy 'elixir-lang/vim-elixir'
    "NeoBundleLazy 'evanmiller/nginx-vim-syntax'
    NeoBundleLazy 'evanmiller/nginx-vim-syntax', {'autoload': {'filetypes': 'nginx'}}
    NeoBundleLazy 'groenewege/vim-less', {
          \ 'autoload' : {
          \   'filetypes' : 'less',
          \ }}

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
    NeoBundleLazy 'tpope/vim-haml'
    NeoBundleLazy 'tpope/vim-markdown', {'autoload':{'filetypes':['markdown']}}
    NeoBundleLazy 'nelstrom/vim-markdown-folding', {'autoload':{'filetypes':['markdown']}}
    NeoBundleLazy 'digitaltoad/vim-jade', {'autoload':{'filetypes':['jade']}}

" }}}  


" Syntax checkers {{{
" ===================
    NeoBundle 'scrooloose/syntastic'
    let g:syntastic_enable_signs = 1
    let g:syntastic_auto_jump = 1
    let g:syntastic_auto_loc_list = 1
    " Disable syntastic for python (managed by python-mode)
    let g:syntastic_mode_map = {
        \ 'mode': 'active',
        \ 'active_filetypes': [],
        \ 'passive_filetypes': ['python'] }

" }}}




" features
" NeoBundleLazy 'ervandew/supertab'
NeoBundleLazy 'nathanaelkane/vim-indent-guides' " color indentation

if has('conceal')
  NeoBundleLazy 'Yggdroot/indentLine'
endif


" NeoBundleLazy 'thinca/vim-quickrun'

" NeoBundle 'scrooloose/nerdcommenter'
NeoBundle 'tomtom/tcomment_vim'

" NeoBundleLazy 'Rykka/riv.vim'
" https://github.com/Rykka/riv.vim/issues/42


"NeoBundleLazy 'Lokaltog/vim-powerline'
" NeoBundleLazy 'terryma/vim-powerline', {'rev':'develop'}


" NeoBundleLazy 'Shougo/neocomplcache'
"NeoBundleLazy 'Shougo/neocomplete'

NeoBundleLazy 'hynek/vim-python-pep8-indent', {
      \ 'filetypes' : 'python',
      \ }

" :Move, :SudoWrite, :Chmod, :Mkdir
NeoBundle 'tpope/vim-eunuch'

" motion
NeoBundle 'Lokaltog/vim-easymotion'

NeoBundle 'vim-scripts/bufkill.vim'
NeoBundle 'editorconfig/editorconfig-vim'


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
