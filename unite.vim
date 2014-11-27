"===============================================================================
" Unite
"===============================================================================
let g:unite_source_session_path = g:SESSION_DIR

" Start in insert mode
let g:unite_enable_start_insert = 1

" Enable short source name in window
" let g:unite_enable_short_source_names = 1

" Enable history yank source
let g:unite_source_history_yank_enable = 1

" Open in bottom right
let g:unite_split_rule = "botright"

let g:unite_enable_split_vertically = 1

" Shorten the default update date of 500ms
let g:unite_update_time = 500

let g:unite_source_file_mru_limit = 300
let g:unite_cursor_line_highlight = 'TabLineSel'

let g:unite_source_file_mru_filename_format = ':~:.'
let g:unite_source_file_mru_time_format = ''

let g:unite_source_grep_max_candidates = 200

if executable('ack')
  " let g:unite_source_rec_async_command = 'ack -f --nofilter'
endif

if executable('ag')
  " let g:unite_source_file_async_command =
  "           \ 'ag --follow --nocolor --nogroup --hidden -g ""'
  " https://github.com/ggreer/the_silver_searcher
  " Use ag in unite grep source.
  " let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden ' .
  "       \ '--ignore ''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'' ' .
  "       \ '--ignore ''**/*.pyc'' -g ""'
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
        \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'' ' .
        \ '--ignore ''**/*.pyc'''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  " Match whole word only. This might/might not be a good idea
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a -H'
  "let g:unite_source_grep_default_opts = '--no-heading --no-color -a -w'
  let g:unite_source_grep_default_opts = '--exclude ''\.(git|svn|hg|bzr)'''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a -w'
  let g:unite_source_grep_default_opts = '--exclude ''\.(git|svn|hg|bzr)'''
  let g:unite_source_grep_recursive_opt = ''
endif

" Quick grep from cwd
nnoremap <silent> <space>g :<C-u>Unite -winwidth=150 grep:%::<CR>
nnoremap <silent> <space>G :<C-u>Unite -buffer-name=search -auto-preview -no-quit -no-empty grep:.::<CR>
