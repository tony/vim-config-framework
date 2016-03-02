"===============================================================================
" Unite
"===============================================================================

function! StartUnite()
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


    " Set up some custom ignores
    " call unite#custom#source('buffer,file,file_rec/async,file_rec,file_mru,file,grep',
    " See ignore.vim

    let g:unite_source_file_rec_max_cache_files = 0
    let g:unite_source_rec_max_cache_files = 0

    let g:unite_source_buffer_time_format = '(%d-%m-%Y %H:%M:%S) '
    let g:unite_source_file_mru_time_format = '(%d-%m-%Y %H:%M:%S) '
    let g:unite_source_directory_mru_time_format = '(%d-%m-%Y %H:%M:%S) '

    if executable('ag')
      let g:unite_source_grep_command='ag'
      let g:unite_source_grep_default_opts =
            \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
            \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'' ' .
            \ '--ignore ''**/*.pyc'''
      let g:unite_source_grep_recursive_opt=''
      let g:unite_source_grep_search_word_highlight = 1
      " let g:unite_source_file_async_command =
      "           \ 'ag --follow --nocolor --nogroup --hidden -g ""'
      " https://github.com/ggreer/the_silver_searcher
      " Use ag in unite grep source.
      let g:unite_source_rec_async_command =
            \ ['ag --follow --nocolor --nogroup --hidden ',
            \ '--ignore ''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'' ',
            \ '--ignore ''**/*.pyc'' -g ""'
            \ ]
      let g:unite_source_grep_command = 'ag'
    elseif executable('ack-grep')
      let g:unite_source_grep_command = 'ack-grep'
      " Match whole word only. This might/might not be a good idea
      let g:unite_source_grep_default_opts = '--no-heading --no-color -a -H'
      "let g:unite_source_grep_default_opts = '--no-heading --no-color -a -w'
      let g:unite_source_grep_default_opts .= '--exclude ''\.(git|svn|hg|bzr)'''
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('ack')
      " let g:unite_source_rec_async_command = 'ack -f --nofilter'
      let g:unite_source_grep_command = 'ack'
      let g:unite_source_grep_default_opts = '--no-heading --no-color -a -w'
      let g:unite_source_grep_default_opts .= '--exclude ''\.(git|svn|hg|bzr)'''
      let g:unite_source_grep_recursive_opt = ''
    endif

    call unite#custom#source('file_rec/async,file_rec/git', 'ignore_globs', [])

    call unite#custom#source('file_rec,file_rec/async,file_rec/git',
          \ 'max_candidates', 1000)
    "# Q: I want the strength of the match to overpower the order in which I list
    " sources.
    call unite#custom#profile('files', 'filters', 'sorter_rank')

    call unite#custom#source(
          \ 'buffer,file_rec', 'matchers',
          \ ['converter_relative_word', 'matcher_fuzzy',
          \  'matcher_project_ignore_files'])
    call unite#custom#source('file_rec/async,file_rec/git', 'matchers', 
          \  [ 'converter_relative_word', 'matcher_default' ])
    call unite#custom#source(
          \ 'file_rec,file_rec/async,file_rec/git,file_mru', 'converters',
          \ ['converter_file_directory'])
    "      \ ['matcher_fuzzy', 'matcher_hide_hidden_files'])
    call unite#custom#source(
          \ 'file_rec,file_rec/async', 'required_pattern_length',
          \ 1)

    " https://github.com/Shougo/unite.vim/issues/467#issuecomment-54888841
    call unite#custom#source('file_rec', 'sorters', 'sorter_length')

    " Map space to the prefix for Unite
    nnoremap [unite] <Nop>
    nmap <space> [unite]

    function! s:ExtractGitProject()
      let b:git_dir = finddir('.git', ';')
      return b:git_dir
    endfunction

    function! UniteGetSource()
      " If inside git dir, do file_rec/git, else file_rec/async
      if exists('b:git_dir') && (b:git_dir ==# '' || b:git_dir =~# '/$')
        unlet b:git_dir
      endif

      if !exists('b:git_dir')
        let dir = s:ExtractGitProject()
        if dir !=# ''
          let b:git_dir = dir
        endif
      endif
      echo b:git_dir
      return b:git_dir !=# '' ? "file_rec/git" : "file_rec/async:!"
    endfunction


    " General fuzzy search
    nnoremap <silent> [unite]<space> :execute "Unite -no-split -no-empty -start-insert " .
         \ "-buffer-name=files buffer " .
         \ UniteGetSource()<CR>

    " Quick registers
    nnoremap <silent> [unite]r :<C-u>Unite -no-split -buffer-name=register register<CR>

    " Quick buffer and mru
    nnoremap <silent> [unite]u :<C-u>Unite -no-split -buffer-name=buffers buffer file_mru<CR>

    "Quick outline
    nnoremap <silent> [unite]o :<C-u>Unite -no-split -buffer-name=outline -vertical outline<CR>

    " Quick outline
    " nnoremap <silent> [unite]o :<C-u>Unite -start-insert -resume outline<CR>

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
    nnoremap <silent> [unite]g :<C-u>Unite -winwidth=150 grep:%::<CR>
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
      nmap <buffer> <C-c> <Plug>(unite_exit)
      imap <buffer> <C-c> <Plug>(unite_exit)
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
      "nnoremap <silent><buffer><expr> <C-s> unite#do_action('split')
      inoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
      "nnoremap <silent><buffer><expr> <C-v> unite#do_action('vsplit')

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

autocmd! User unite.vim call StartUnite()
