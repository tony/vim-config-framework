" Credit: https://github.com/ryanpcmcquen/fix-vim-pasting/
" License: https://github.com/ryanpcmcquen/fix-vim-pasting/blob/95ee17a/LICENSE
" Accessed Jan 1st, 2022
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
    set pastetoggle=<Esc>[201~
    set paste
    return ""
endfunction
