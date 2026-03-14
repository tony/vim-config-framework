" Set shell for Windows systems
if has('win16') || has('win32') || has('win64')
    set shell=/bin/sh
endif

" Root and state helpers for the main config and the test harness.
function! lib#IsTestMode() abort
  return get(g:, 'vim_test_mode', 0) ? 1 : 0
endfunction

function! lib#ResolvePath(path) abort
  return fnamemodify(expandcmd(a:path), ':p')
endfunction

function! lib#JoinPath(root, leaf) abort
  return fnamemodify(a:root . '/' . a:leaf, ':p')
endfunction

function! lib#ConfigRoot() abort
  return lib#ResolvePath(get(g:, 'vim_config_root', '~/.vim'))
endfunction

function! lib#PluginRoot() abort
  return lib#ResolvePath(get(g:, 'vim_plugin_root', lib#JoinPath(lib#ConfigRoot(), 'plugged')))
endfunction

function! lib#FzfRoot() abort
  return lib#ResolvePath(get(g:, 'vim_fzf_root', '~/.fzf'))
endfunction

function! lib#StateRoot() abort
  return lib#ResolvePath(get(g:, 'vim_state_root', '~/.local/share'))
endfunction

function! lib#ConfigPath(path) abort
  return lib#JoinPath(lib#ConfigRoot(), a:path)
endfunction

function! lib#StatePath(path) abort
  return lib#JoinPath(lib#StateRoot(), a:path)
endfunction

" Function to source only if file exists {
function! lib#SourceIfExists(file) abort
  let l:path = lib#ResolvePath(a:file)
  if filereadable(l:path)
    execute 'source' fnameescape(l:path)
  endif
endfunction
" }


function! lib#ColorSchemeExists(colorscheme)
  try
      exe 'colorscheme' a:colorscheme
      return 1
  catch /^Vim\%((\a\+)\)\=:E185/
      return 0
  endtry
endfunction
