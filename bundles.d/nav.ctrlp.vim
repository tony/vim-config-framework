" Find files
NeoBundle 'ctrlpvim/ctrlp.vim', 
      \ {'autoload': {'commands': ['CtrlP', 'CtrlPBuffer', 'CtrlPMRU', 'CtrlPLastMode', 'CtrlPRoot', 'CtrlPClearCache', 'CtrlPClearAllCaches']}}
NeoBundleLazy 'tacahiroy/ctrlp-funky',
      \ {'autoload': {'commands': ['CtrlPFunky']}}
NeoBundle 'FelikZ/ctrlp-py-matcher', {
      \   'depends' : 'ctrlpvim/ctrlp.vim'
      \}
