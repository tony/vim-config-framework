"===============================================================================
" Unite
"===============================================================================
let bundle = neobundle#get('unite.vim')
function! bundle.hooks.on_source(bundle)
  let g:unite_source_session_path = g:SESSION_DIR

  " Start in insert mode
  let g:unite_enable_start_insert = 1

  " Enable short source name in window
  " let g:unite_enable_short_source_names = 1

  " Enable history yank source
  let g:unite_source_history_yank_enable = 1

  " Open in bottom right
  let g:unite_split_rule = "botright"

  let g:unite_enable_split_vertically = 0

  let g:unite_winheight = 20


  " Shorten the default update date of 500ms
  let g:unite_update_time = 200

  let g:unite_source_file_mru_limit = 300
  let g:unite_cursor_line_highlight = 'TabLineSel'

  let g:unite_source_file_mru_filename_format = ':~:.'
  let g:unite_source_file_mru_time_format = ''

  " For ag, ack
  " https://github.com/ggreer/the_silver_searcher
  " apt-get install software-properties-common # (if required)
  " apt-add-repository ppa:mizuno-as/silversearcher-ag
  " apt-get update
  " apt-get install silversearcher-ag
  "
  "
  let g:unite_source_grep_max_candidates = 200

  if executable('ag')
    " Use ag in unite grep source.
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
    \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
    \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
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

  " Use the fuzzy matcher for everything
  call unite#filters#matcher_default#use(['matcher_fuzzy'])

  " Use the rank sorter for everything
  call unite#filters#sorter_default#use(['sorter_rank'])

  " Set up some custom ignores
  " call unite#custom#source('buffer,file,file_rec/async,file_rec,file_mru,file,grep',
  " See ignore.vim

  " Custom filters."{{{
  call unite#custom#source(
        \ 'buffer,file_rec,file_rec/async', 'matchers',
        \ ['converter_tail', 'matcher_fuzzy'])
  call unite#custom#source(
        \ 'file_mru,neomru/file', 'matchers',
        \ ['matcher_project_files', 'matcher_fuzzy', 'matcher_hide_hidden_files'])

  call unite#custom#source(
        \ 'file', 'matchers',
        \ ['matcher_fuzzy', 'matcher_hide_hidden_files'])
  call unite#custom#source(
        \ 'file_rec/async,file_mru', 'converters',
        \ ['converter_file_directory'])

  " Map space to the prefix for Unite
  nnoremap [unite] <Nop>
  nmap <space> [unite]

  " General fuzzy search
  nnoremap <silent> [unite]<space> :<C-u>Unite -no-split
        \ -buffer-name=files buffer neomru/file file_rec:! file_rec/async:! <CR>

  " Quick registers
  nnoremap <silent> [unite]r :<C-u>Unite -no-split -buffer-name=register register<CR>

  " Quick buffer and mru
  nnoremap <silent> [unite]u :<C-u>Unite -no-split -buffer-name=buffers buffer file_mru<CR>

  " Quick yank history
  nnoremap <silent> [unite]y :<C-u>Unite -no-split -buffer-name=yanks history/yank<CR>

  " Quick outline
  " nnoremap <silent> [unite]o :<C-u>Unite -no-split -buffer-name=outline -vertical outline<CR>

  " Quick outline
  nnoremap <silent> [unite]o :<C-u>Unite -start-insert -resume outline<CR>

  " Quick sessions (projects)
  nnoremap <silent> [unite]p :<C-u>Unite -no-split -buffer-name=sessions session<CR>

  " Quick sources
  nnoremap <silent> [unite]a :<C-u>Unite -no-split -buffer-name=sources source<CR>

  " Quick snippet
  nnoremap <silent> [unite]s :<C-u>Unite -no-split -buffer-name=snippets snippet<CR>

  " Quickly switch lcd
  nnoremap <silent> [unite]d
        \ :<C-u>Unite -buffer-name=change-cwd -default-action=lcd directory_mru<CR>

  " Quick file search
  nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=files file_rec/async file/new<CR>

  " Quick grep from cwd
  nnoremap <silent> [unite]g :<C-u>Unite grep:%::<CR>
  nnoremap <silent> [unite]G :<C-u>Unite -buffer-name=search -auto-preview -no-quit -no-empty grep:.::<CR>

  " Quick help
  nnoremap <silent> [unite]h :<C-u>Unite -buffer-name=help help<CR>

  " Quick line using the word under cursor
  nnoremap <silent> [unite]l :<C-u>Unite -buffer-name=search_file line<CR>
  nnoremap <silent> [unite]L :<C-u>UniteWithCursorWord -buffer-name=search_file line<CR>

  " Quick MRU search
  nnoremap <silent> [unite]m :<C-u>Unite -buffer-name=mru file_mru<CR>

  " Quick find
  nnoremap <silent> [unite]n :<C-u>Unite -buffer-name=find find:.<CR>

  " Quick commands
  nnoremap <silent> [unite]c :<C-u>Unite -buffer-name=commands command<CR>

  " Quick bookmarks
  " nnoremap <silent> [unite]b :<C-u>Unite -buffer-name=bookmarks bookmark<CR>

  " Fuzzy search from current buffer
   nnoremap <silent> [unite]b :<C-u>UniteWithBufferDir -no-split 
         \ -buffer-name=files -prompt=%\  buffer file_mru bookmark file<CR>

  " Quick commands
  nnoremap <silent> [unite]; :<C-u>Unite -buffer-name=history history/command command<CR>

  " Custom Unite settings
  function! s:unite_my_settings()

    nmap <buffer> <ESC> <Plug>(unite_exit)
    nmap <buffer> <c-c> <Plug>(unite_exit)
    imap <buffer> <ESC> <Plug>(unite_exit)
    "imap <buffer> <c-j> <Plug>(unite_select_next_line)
    "imap <buffer><expr> j unite#smart_map('j', '')
    imap <buffer> jj <Plug>(unite_insert_leave)
    imap <buffer> <c-j> <Plug>(unite_insert_leave)
    nmap <buffer> <c-j> <Plug>(unite_loop_cursor_down)
    nmap <buffer> <c-k> <Plug>(unite_loop_cursor_up)
    imap <buffer> <c-a> <Plug>(unite_choose_action)
    imap <buffer> <Tab> <Plug>(unite_insert_leave)
    imap <buffer> jj <Plug>(unite_insert_leave)
    imap <buffer> <C-w> <Plug>(unite_delete_backward_word)
    imap <buffer> <C-u> <Plug>(unite_delete_backward_path)
    imap <buffer> '     <Plug>(unite_quick_match_default_action)
    nmap <buffer> '     <Plug>(unite_quick_match_default_action)
    nmap <buffer> <C-r> <Plug>(unite_redraw)
    imap <buffer> <C-r> <Plug>(unite_redraw)
    inoremap <silent><buffer><expr> <C-s> unite#do_action('split')
    nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
    inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
    nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')

    let unite = unite#get_current_unite()
    if unite.buffer_name =~# '^search'
      nnoremap <silent><buffer><expr> r     unite#do_action('replace')
    else
      nnoremap <silent><buffer><expr> r     unite#do_action('rename')
    endif

    nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')

    " Using Ctrl-\ to trigger outline, so close it using the same keystroke
    if unite.buffer_name =~# '^outline'
      imap <buffer> <C-\> <Plug>(unite_exit)
    endif

    " Using Ctrl-/ to trigger line, close it using same keystroke
    if unite.buffer_name =~# '^search_file'
      imap <buffer> <C-_> <Plug>(unite_exit)
    endif
  endfunction

  autocmd MyAutoCmd FileType unite call s:unite_my_settings()
endfunction

unlet bundle
