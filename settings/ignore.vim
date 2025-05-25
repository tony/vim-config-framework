" Single source of truth for ignore patterns
let s:ignore_patterns = {
      \ 'temp_files': ['*~', '*.swp', '*.tmp', '*.bak', '*.BAK', '*.DAT'],
      \ 'python': ['*.pyc', '*.pyo', '__pycache__', '*.egg', '*.egg-info', '.tox', '.mypy_cache', '.ruff_cache', '.pytest_cache', '.coverage'],
      \ 'vcs': ['.git', '.hg', '.svn', '.bzr'],
      \ 'env': ['.env', '.env[0-9]', '.env-pypy', '.venv', '.venv[0-9]', '.venv-pypy'],
      \ 'ide': ['.idea', '.vscode', '.ropeproject'],
      \ 'web': ['.sass-cache', '.webassets-cache', 'node_modules', 'bower_components'],
      \ 'os': ['.DS_Store', '.Trash'],
      \ 'build': ['*.o', '*.obj', '*.debug.d', '*.debug.o', '*.so', 'vendor/rails', 'vendor/cache', '*.gem'],
      \ 'logs': ['log', 'tmp'],
      \ 'media': ['*.png', '*.jpg', '*.gif', '*.pdf', '*.dmg', '*.zip', '*.tar.gz'],
      \ 'misc': ['.gitkeep', '.vagrant', '.splinter-screenshots', '.ipynb_checkpoints', '.*_cache', '.nx', '*.app']
      \ }

" Flatten all patterns into a single list
let s:all_patterns = []
for patterns in values(s:ignore_patterns)
  let s:all_patterns += patterns
endfor

" Configure NERDTree
let g:NERDTreeIgnore = []
for pattern in s:all_patterns
  " NERDTree uses regex, so escape special chars and handle extensions
  if pattern =~ '^\*\.'
    " Convert *.ext to \.ext$
    call add(g:NERDTreeIgnore, '\' . pattern[1:] . '$')
  elseif pattern =~ '^\.'
    " Directory patterns
    call add(g:NERDTreeIgnore, pattern)
  else
    " Other patterns
    call add(g:NERDTreeIgnore, pattern)
  endif
endfor

" Configure wildignore
set wildignore=
for pattern in s:all_patterns
  execute 'set wildignore+=' . pattern
endfor
" Add directory-specific patterns
set wildignore+=*/.__pycache__/**
set wildignore+=*/.sass-cache/**
set wildignore+=*/.vscode/**
set wildignore+=*/vendor/rails/**
set wildignore+=*/vendor/cache/**
set wildignore+=*/log/**
set wildignore+=*/tmp/**
set wildignore+=*/.tox/**
set wildignore+=*/.idea/**
set wildignore+=*/.vagrant/**
set wildignore+=*/.coverage/**

" Configure netrw
let g:netrw_list_hide = ''
for pattern in s:all_patterns
  if pattern =~ '^\*\.'
    " Convert *.ext to \.ext,
    let g:netrw_list_hide .= '\' . pattern[1:] . ','
  elseif pattern =~ '\[.\]'
    " Handle patterns with brackets
    let g:netrw_list_hide .= substitute(pattern, '\[', '\\[', 'g') . ','
  else
    let g:netrw_list_hide .= pattern . ','
  endif
endfor
" Add directory patterns
let g:netrw_list_hide .= '__pycache__/,\.sass-cache/,\.vscode/,vendor/rails/,vendor/cache/,log/,tmp/,\.tox/,\.idea/,\.vagrant/,\.coverage/,'

