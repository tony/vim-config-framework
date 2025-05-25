function! settings#LoadSettings() abort
  call lib#SourceIfExists("~/.vim/settings/autocmd.vim")
  call lib#SourceIfExists("~/.vim/settings/settings.vim")
  call lib#SourceIfExists("~/.vim/settings/ignore.vim")
  call lib#SourceIfExists("~/.vim/settings/sensible.vim")

  call lib#SourceIfExists("~/.vim/settings/keymappings.vim")
  call lib#SourceIfExists("~/.vim/plugin_loader.vim")

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
          \ '.env3/',
          \ '.venv3/',
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

  " An action can be a reference to a function that processes selected lines
  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction

  " This is the default extra key bindings
  let g:fzf_action = {
    \ 'ctrl-q': function('s:build_quickfix_list'),
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

  if v:version >= 801  " Floating window on 8.1+ https://github.com/junegunn/fzf/blob/master/README-VIM.md
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
  endif

  " Customize fzf colors to match your color scheme
  let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }

  " Enable per-command history.
  " CTRL-N and CTRL-P will be automatically bound to next-history and
  " previous-history instead of down and up. If you don't like the change,
  " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
  let g:fzf_history_dir = '~/.local/share/fzf-history'



  function! OnLoadFZF()
    if !exists(':FZF')
      return
    endif

    " Use vim-rooter's FindRootDirectory for project-aware file search
    if exists('*fzf#wrap') && exists('*FindRootDirectory')
      command! -bang FZFRoot
        \ call fzf#run(fzf#wrap({'dir': FindRootDirectory()}, <bang>0))
      nmap <space> :<C-u>FZFRoot<CR>
    endif
    
    " Use ripgrep for searching
    if exists(':Rg')
      nnoremap <silent> <C-F> :<C-u>Rg<cr>
    endif
  endfunction

  call plugin_loader#PlugOnLoad('fzf.vim', 'call OnLoadFZF()')






  if executable('rg')
    command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview(), <bang>0)

    function! RipgrepFzf(query, fullscreen)
      let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
      let initial_command = printf(command_fmt, shellescape(a:query))
      let reload_command = printf(command_fmt, '{q}')
      let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
      call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    endfunction

    command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
  endif

endfunction

" Statusline settings
" set laststatus=2  " Already set by sensible.vim
set cmdheight=1   " Single line for command area (default)
