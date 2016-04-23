if executable('rustc')
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'phildawes/racer', { 'do': 'cargo build --release', 'for': 'rust' }

  let g:racer_cmd = "~/.vim/bundle/racer"
endif

