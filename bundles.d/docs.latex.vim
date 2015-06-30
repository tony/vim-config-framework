if executable('latex')
  NeoBundleLazy 'LaTeX-Box-Team/LaTeX-Box', { 'autoload' :
        \   { 'filetypes' : [ 'tex'
        \ , 'latex'
        \ ]
        \   }
        \ }
endif
