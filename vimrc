"------------------------------------------------------------------------------
" Basic Recommended Settings
"------------------------------------------------------------------------------
" Make the config self-locating so wrappers can source it directly.
let g:vim_config_root = get(g:, 'vim_config_root', fnamemodify(expand('<sfile>:p:h'), ':p'))

if index(split(&runtimepath, ','), g:vim_config_root) < 0
  let &runtimepath = g:vim_config_root . ',' . &runtimepath
endif

if index(split(&packpath, ','), g:vim_config_root) < 0
  let &packpath = g:vim_config_root . ',' . &packpath
endif

"------------------------------------------------------------------------------
" Helper Function for Conditional Sourcing
"------------------------------------------------------------------------------
" Use lib#SourceIfExists from autoload/lib.vim instead of defining here


"------------------------------------------------------------------------------
" ALE Configuration
"------------------------------------------------------------------------------
" Buffer & File Handling
"------------------------------------------------------------------------------
" Allow switching away from unsaved buffers
set hidden

" Fix backspace behavior (sensible.vim sets backspace=indent,eol,start)
" set backspace=2

" Disable swap/backup files
set nobackup
set nowritebackup
set noswapfile

" Performance settings (from rice.vim)
set lazyredraw

" Disable matchparen plugin (avoid glitchy behavior)
let g:loaded_matchparen = 1  " or use `:NoMatchParen`

"------------------------------------------------------------------------------
" Clipboard Behavior
"------------------------------------------------------------------------------
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif

"------------------------------------------------------------------------------
" Netrw Tweak
"------------------------------------------------------------------------------
augroup MyNetrwFix
  autocmd!
  " Fix netrw so that its buffer is hidden on exit
  autocmd FileType netrw setlocal bufhidden=delete
augroup END

"------------------------------------------------------------------------------
" Truecolor Support (especially under tmux)
"------------------------------------------------------------------------------
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"------------------------------------------------------------------------------
" Auto-install vim-plug if not present
"------------------------------------------------------------------------------
let s:plug_vim = lib#ConfigPath('autoload/plug.vim')
if !lib#IsTestMode() && empty(glob(s:plug_vim)) && empty($GIT_DIR)
  silent execute '!curl -fLo ' . shellescape(s:plug_vim) . ' --create-dirs'
        \ . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

"------------------------------------------------------------------------------
" Load Plugins and Settings
"------------------------------------------------------------------------------
execute 'source' fnameescape(lib#ConfigPath('plugins.vim'))

" Automatically install missing plugins on startup
if !lib#IsTestMode() && !empty(filter(copy(g:plugs), '!isdirectory(v:val.dir)')) && empty($GIT_DIR)
  autocmd VimEnter * PlugInstall
endif

call settings#LoadSettings()
" highlight.vim merged into settings.vim

"------------------------------------------------------------------------------
" Color Schemes - Simplified Fallback Logic
"------------------------------------------------------------------------------
" Define colorschemes in order of preference
let s:colorschemes = [
  \ {'name': 'tokyonight-moon', 'only_nvim': 1},
  \ {'name': 'tokyonight'},
  \ {'name': 'catppuccin_mocha'},
  \ {'name': 'gruvbox'},
  \ {'name': 'gruvbox-material', 'setup': 'let g:gruvbox_material_disable_italic_comment = 1'},
  \ {'name': 'everforest', 'setup': 'set background=dark | let g:everforest_background = "hard" | let g:everforest_transparent_background = 2 | let g:everforest_disable_italic_comment = 1'},
  \ {'name': 'desert-warm-256'},
  \ ]

" Try each colorscheme in order
if exists('*lib#ColorSchemeExists')
  for scheme in s:colorschemes
    if has_key(scheme, 'only_nvim') && !has('nvim')
      continue
    endif
    if lib#ColorSchemeExists(scheme.name)
      if has_key(scheme, 'setup')
        execute scheme.setup
      endif
      execute 'colorscheme' scheme.name
      break
    endif
  endfor
else
  " Fallback if ColorSchemeExists is not available
  colorscheme desert
endif

"------------------------------------------------------------------------------
" Local Customizations
"------------------------------------------------------------------------------
if !lib#IsTestMode()
  call lib#SourceIfExists(expand('$HOME/.vimrc.local'))
endif
