function! StartIndentLine()
	let g:indentLine_color_term = 239
endfunction

call PlugOnLoad('indentLine', 'call StartIndentLine()')
