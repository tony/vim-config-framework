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

call PlugOnLoad('vim-rooter', 'call StartVimRooter()')
