function! StartIndentGuides()
	let indent_guides_enable_on_vim_startup = 0
	let indent_guides_auto_colors = 0

	hi IndentGuidesOdd  ctermbg=black
	hi IndentGuidesEven ctermbg=darkgrey
endfunction

call PlugOnLoad('vim-indent-guides', 'call StartIndentGuides()')
