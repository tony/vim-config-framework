NeoBundleLazy 'OmniSharp/omnisharp-vim', {
      \   'autoload': {'filetypes': ['cs']},
      \   'build': {
      \     'windows': 'MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
      \     'mac': 'xbuild server/OmniSharp.sln',
      \     'unix': 'xbuild server/OmniSharp.sln',
      \   },
      \ 'build_commands' : ['xbuild'],
      \ }

