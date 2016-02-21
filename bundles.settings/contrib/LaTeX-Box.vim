function! StartLaTeXBox()

    "{{{2 latex
    let g:latex_enabled = 1
    let g:latex_viewer = 'mupdf -r 95'
    let g:latex_default_mappings = 1

    let g:LatexBox_latexmk_async = 1
    let g:LatexBox_latexmk_preview_continuously = 1
    let g:LatexBox_Folding = 1
    let g:LatexBox_viewer = 'mupdf -r 95'
    let g:LatexBox_quickfix = 2
    let g:LatexBox_split_resize = 1

    let g:LatexBox_latexmk_options
          \ = "-pdflatex='pdflatex -synctex=1 \%O \%S'"
endfunction

autocmd! User LaTeX-Box call StartLaTeXBox()
