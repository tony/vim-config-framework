Plug 'Shutnik/jshint2.vim'

Plug 'elzr/vim-json', {
      \ 'autoload' : {
      \   'filetypes' : 'javascript',
      \ }}


Plug 'pangloss/vim-javascript', {
      \ 'autoload' : {
      \   'filetypes' : ['javascript', 'jsx']
      \ }}

if executable('node')
  function! NpmInstall(info)
	  if a:info.status == 'installed' || a:info.force
		      !npm install
		        endif
  endfunction
  Plug 'marijnh/tern_for_vim', { 'do': function('NpmInstall') }

  Plug 'maksimr/vim-jsbeautify', {
        \ 'for' : ['javascript', 'html', 'mustache', 'css', 'less', 'jst']
        \ }

  Plug 'einars/js-beautify', { 'do': function('NpmInstall') }

  Plug 'ramitos/jsctags', { 'do': function('NpmInstall') }
endif

if executable('tsc')
  Plug 'Quramy/tsuquyomi'

  Plug 'leafgarland/typescript-vim'
endif
