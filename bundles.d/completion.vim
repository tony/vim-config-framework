NeoBundleLazy 'Shougo/neocomplete.vim', { 'autoload' : { 'insert' : '1' }, 'disabled' : (!has('lua') || has('nvim')) }
NeoBundleLazy 'Shougo/deoplete.vim', { 'autoload' : { 'insert' : '1' }, 'disabled' : !has('nvim') }

NeoBundleLazy 'Shougo/context_filetype.vim', { 'autoload' : { 'function_prefix' : 'context_filetype' } }
