autocmd QuickFixCmdPost *grep* cwindow

" Simple quickfix toggle using built-in commands
nnoremap <leader>q :cwindow<CR>
nnoremap <C-q> :cclose<CR>