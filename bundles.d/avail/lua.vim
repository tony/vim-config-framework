if executable('lua')

  NeoBundleLazy 'xolox/vim-lua-ftplugin' , {
        \ 'autoload' : {'filetypes' : 'lua'},
        \ 'depends' : 'xolox/vim-misc',
        \ }
endif
