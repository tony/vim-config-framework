if executable('rustc')
  NeoBundle 'rust-lang/rust.vim'

  NeoBundleLazy 'phildawes/racer', {
        \   'build' : {
        \     'mac': 'cargo build --release',
        \     'unix': 'cargo build --release',
        \   },
        \ 'build_commands' : ['rustc', 'cargo'],
        \ 'external_commands' : ['rustc', 'cargo'],
        \   'autoload' : {
        \     'filetypes': 'rust',
        \   },
        \ }
  let g:racer_cmd = "~/.vim/bundle/racer"
endif

