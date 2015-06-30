if executable('docker')
  NeoBundleLazy 'ekalinin/Dockerfile.vim',
        \ {'autoload': {'filetypes': 'Dockerfile'}}
endif
