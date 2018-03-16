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

call PlugOnLoad('vim-rooter', 'call StartVimRooter()')
