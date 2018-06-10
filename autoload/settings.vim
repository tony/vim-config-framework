function! settings#LoadSettings() abort
  call lib#SourceIfExists("~/.vim/settings/settings.vim")
  call lib#SourceIfExists("~/.vim/settings/ignore.vim")
  call lib#SourceIfExists("~/.vim/settings/sensible.vim")

  call lib#SourceIfExists("~/.vim/settings/keymappings.vim")
  call lib#SourceIfExists("~/.vim/plugin_loader.vim")

  call lib#SourceIfExists("~/.vimrc.local")

  "
  " vim-rooter
  "

  " This is checked for before initialization.
  " https://github.com/airblade/vim-rooter/blob/3509dfb/plugin/rooter.vim#L173
  let g:rooter_manual_only = 1

  function! StartVimRooter()
      " airblade/vim-rooter
      let g:rooter_patterns = [
          \ 'manage.py', 
          \ '.venv/', 
          \ '.env/',
          \ 'Rakefile',
          \ '.git/',
          \ 'gulpfile.js',
          \ 'bower.json',
          \ 'Gruntfile.js',
          \ 'Gemfile',
          \ 'Procfile',
          \ '.svn',
          \ '.hg',
          \ 'Pipfile',
          \ ]
      let g:rooter_silent_chdir = 1
  endfunction

  call plugin_loader#PlugOnLoad('vim-rooter', 'call StartVimRooter()')

  "
  " Base 16
  "

  function! LoadBase16ColorScheme()
    " 256bit terminal
    set t_Co=256
    let g:base16_scheme = $BASE16_SCHEME
    let g:base16_scheme_path = '~/.vim/plugged/base16-vim/colors/base16-' . g:base16_scheme . '.vim'
    if filereadable(expand(g:base16_scheme_path))
      let g:base16colorspace=256  " Access colors present in 256 colorspace
      exe 'colorscheme base16-' . g:base16_scheme
    else
      colorscheme desert
    endif
  endfunction

  call plugin_loader#PlugOnLoad('base16-vim', 'call LoadBase16ColorScheme()')
endfunction
