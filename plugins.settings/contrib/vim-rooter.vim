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
endfunction

call PlugOnLoad('vim-rooter', 'call StartVimRooter()')
