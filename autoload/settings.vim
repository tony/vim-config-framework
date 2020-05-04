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


  function! s:find_root()
    for vcs in ['.venv', 'Pipfile', 'Procfile', 'Gemfile', '.git', '.svn', '.hg']
      let dir = finddir(vcs.'/..', ';')
      if !empty(dir)
        execute 'FZF' dir
        return
      endif
    endfor
    FZF
  endfunction

  " command! FZFR call s:find_root()

  command! -bang FZFR
    \ call fzf#run(fzf#wrap('my-stuff', {'dir': FindRootDirectory()}, <bang>0))



  nmap <space> :<C-u>FZFR<CR>
  "nmap <space> :<C-u>FZF<CR>


  """"
  " Tags in buffer
  "
  " https://github.com/junegunn/fzf/wiki/Examples-(vim)#jump-to-tags-in-the-current-buffer
  " Accessed March 14th, 2018
  """"
  function! s:align_lists(lists)
    let maxes = {}
    for list in a:lists
      let i = 0
      while i < len(list)
        let maxes[i] = max([get(maxes, i, 0), len(list[i])])
        let i += 1
      endwhile
    endfor
    for list in a:lists
      call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
    endfor
    return a:lists
  endfunction

  function! s:btags_source()
    let lines = map(split(system(printf(
      \ 'ctags -f - --sort=no --excmd=number --language-force=%s %s',
      \ &filetype, expand('%:S'))), "\n"), 'split(v:val, "\t")')
    if v:shell_error
      throw 'failed to extract tags'
    endif
    return map(s:align_lists(lines), 'join(v:val, "\t")')
  endfunction

  function! s:btags_sink(line)
    execute split(a:line, "\t")[2]
  endfunction

  function! s:btags()
    try
      call fzf#run({
      \ 'source':  s:btags_source(),
      \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
      \ 'down':    '40%',
      \ 'sink':    function('s:btags_sink')})
    catch
      echohl WarningMsg
      echom v:exception
      echohl None
    endtry
  endfunction

  command! BTags call s:btags()


  nmap <space> :<C-u>FZFR<CR>
  nmap <C-o> :<C-u>BTags<CR>


  """
  " AG Search
  "
  " https://github.com/junegunn/fzf/wiki/Examples-(vim)#narrow-ag-results-within-vim
  "
  " Accessed March 14, 2018
  """
  function! s:ag_to_qf(line)
    let parts = split(a:line, ':')
    return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
          \ 'text': join(parts[3:], ':')}
  endfunction

  function! s:ag_handler(lines)
    if len(a:lines) < 2 | return | endif

    let cmd = get({'ctrl-x': 'split',
                 \ 'ctrl-v': 'vertical split',
                 \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
    let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

    let first = list[0]
    execute cmd escape(first.filename, ' %#\')
    execute first.lnum
    execute 'normal!' first.col.'|zz'

    if len(list) > 1
      call setqflist(list)
      copen
      wincmd p
    endif
  endfunction

  command! -nargs=* FZFAgRoot call fzf#run({
  \ 'source':  printf('ag --nogroup --column --color "%s" %s',
  \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\'), FindRootDirectory()),
  \ 'sink*':    function('<sid>ag_handler'),
  \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
  \            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
  \            '--color hl:68,hl+:110',
  \ 'down':    '50%'
  \ })

  command! -nargs=* FZFAg call fzf#run({
  \ 'source':  printf('ag --nogroup --column --color "%s"',
  \                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
  \ 'sink*':    function('<sid>ag_handler'),
  \ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
  \            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
  \            '--color hl:68,hl+:110',
  \ 'down':    '50%'
  \ })

  nnoremap <silent> <C-F> :<C-u>FZFAg<cr>
  nnoremap <silent> <C-f> :<C-u>FZFAgRoot<cr>
endfunction

" if v:version >= 802
"   set completeopt+=popup
"   set cmdheight=1  " Used to show docs when popup not available
"   set laststatus=1
" else
  set laststatus=2
  set cmdheight=2  " Used to show docs when popup not available
" endif
