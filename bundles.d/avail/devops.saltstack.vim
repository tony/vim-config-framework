if executable('salt-call')
  NeoBundleLazy 'saltstack/salt-vim',
      \ {'autoload': {'filetypes': 'sls'}}
endif
