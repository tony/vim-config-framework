if executable('ag')
  NeoBundleLazy 'rking/ag.vim', {
        \ 'autoload': {
        \   'commands': ['Ag', 'grep'],
        \ },
        \ 'external_command': 'ag',
        \ }
endif

