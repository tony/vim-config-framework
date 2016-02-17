"
" pyenv with a python 3 virtualenv will not find a python2
" in PATH on most systems, such `python` is normally that.
"
" Disable loading python 2 on neovim if python 
"
" Snippet comes from https://github.com/neovim/neovim/issues/1179
"
let s:get_version =
      \ ' -c "import sys; sys.stdout.write(str(sys.version_info.major))"'

if executable('python') && '3' == system('python'.s:get_version)
  let g:loaded_python_provider = 1
elseif executable('python') && '2' == system('python'.s:get_version)
  "let g:python3_host_prog = '/usr/local/bin/python3'
endif
