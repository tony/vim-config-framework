autocmd QuickFixCmdPost *grep* cwindow

function! QFwinnr() 
   let i=1 
   while i <= winnr('$') 
       if getbufvar(winbufnr(i), '&buftype') == 'quickfix' 
           return i 
       endif 
       let i += 1 
   endwhile 
   return 0 
endfunction 

function! QFCurrent() 
 if getbufvar(winbufnr('%'), '&buftype') == 'quickfix' 
     return 1
 else
     return 0 
 endif
endfunction 

function! BufTypeCurrent() 
 return getbufvar(winbufnr('%'), '&buftype')
endfunction 

nnoremap <leader>q :call QuickfixToggle()<cr>
nnoremap <C-q> :call QuickfixToggle()<cr>

let g:quickfix_is_open = 0

function! QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction


"augroup QuickFixMap
"    autocmd! BufEnter * :if &buftype is# 'quickfix' | nnoremap <silent> <buffer> <C-p> :cp<CR> | endif
"    autocmd! BufEnter * :if &buftype is# 'quickfix' | nnoremap <silent> <buffer> <Leader>p :cp<CR> | endif
"    autocmd! BufEnter * :if &buftype is# 'quickfix' | nnoremap <silent> <buffer> <C-n> :cn<CR> | endif
"    autocmd! BufEnter * :if &buftype is# 'quickfix' | nnoremap <silent> <buffer> <Leader>n :cn<CR> | endif
"augroup END

function! NextBufferOrQuickfix()
    if QFwinnr()
      execute ':cn'
    else
      execute ':bnext'
    endif
endfunction

function! PrevBufferOrQuickfix()
    "if &buftype=="quickfix"
    if QFwinnr()
      execute ':cp'
    else
      execute ':bprev'
    endif
endfunction
