"===============================================================================
" Vimfiler
"===============================================================================
function! StartVimfiler()
	" TODO Look into Vimfiler more
	" Example at: https://github.com/hrsh7th/dotfiles/blob/master/vim/.vimrc

	let g:vimfiler_as_default_explorer = 0
	" let g:vimfiler_tree_leaf_icon = '  '
	" let g:vimfiler_tree_opened_icon = '▾'
	" let g:vimfiler_tree_closed_icon = '▸'
	" let g:vimfiler_file_icon = '-'
	" let g:vimfiler_marked_file_icon = '✓'
	" let g:vimfiler_readonly_file_icon = ' '
	let g:my_vimfiler_explorer_name = 'explorer'
	let g:my_vimfiler_winwidth = 30
	let g:vimfiler_safe_mode_by_default = 1
	let g:vimfiler_directory_display_top = 1
	let g:vimfiler_force_overwrite_statusline = 0

	" let g:vimfiler_ignore_pattern
	" See ignore.vim

	autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
	function! s:vimfiler_settings()
		let g:vimfiler_enable_auto_cd = 1

		set nonumber
		set norelativenumber

		nmap     <buffer><expr><CR>  vimfiler#smart_cursor_map("\<PLUG>(vimfiler_expand_tree)", "e")

		nunmap <buffer> N

		" Traversal
		nnoremap <buffer> <C-h> <C-w>h
		nnoremap <buffer> <C-j> <C-w>j
		nnoremap <buffer> <C-k> <C-w>k
		nnoremap <buffer> <C-l> <C-w>l

		" Close
		nnoremap <buffer> <C-c> :close<CR>

		" Ctrl-h toggle hidden files
		nmap <buffer> <C-h> <Plug>(vimfiler_toggle_visible_ignore_files)
		nmap <buffer> i <Plug>(vimfiler_toggle_visible_ignore_files)

		" Backspace, - and u move parent directory.
		nmap <buffer> <BS> <Plug>(vimfiler_switch_to_parent_directory)
		nmap <buffer> - <Plug>(vimfiler_switch_to_parent_directory)
		nmap <buffer> u <Plug>(vimfiler_switch_to_parent_directory)

		" Refresh files
		nmap <buffer> r <Plug>(vimfiler_redraw_screen)
		nmap <buffer> R <Plug>(vimfiler_redraw_screen)

		" Try to enable basic folding
		nmap <buffer> zR <Plug>(vimfiler_expand_tree_recursive)
		nmap <buffer> zM <Plug>(vimfiler_expand_tree_recursive)
		nmap <buffer> zO <Plug>(vimfiler_expand_tree)
		nmap <buffer> zc <Plug>(vimfiler_expand_tree)
		nmap <buffer> zo <Plug>(vimfiler_expand_tree)
	endfunction

	"autocmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
endfunction

call PlugOnLoad('vimfiler', 'call StartVimfiler()')
