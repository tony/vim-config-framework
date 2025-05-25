"------------------------------------------------------------------------------
" Basic Recommended Settings
"------------------------------------------------------------------------------
if v:version >= 800
  set nocompatible
  syntax on
  filetype plugin indent on
endif

"------------------------------------------------------------------------------
" Fallback for older Vim (comment out if unnecessary)
"------------------------------------------------------------------------------
" set nocompatible
" syntax enable
" filetype plugin on
" filetype indent on

"------------------------------------------------------------------------------
" Helper Function for Conditional Sourcing
"------------------------------------------------------------------------------
" Use lib#SourceIfExists from autoload/lib.vim instead of defining here

"------------------------------------------------------------------------------
" Session / Directory Locations
"------------------------------------------------------------------------------
let g:SESSION_DIR = expand('$HOME/.cache/vim/sessions')

"------------------------------------------------------------------------------
" ALE Configuration
"------------------------------------------------------------------------------
" Buffer & File Handling
"------------------------------------------------------------------------------
" Allow switching away from unsaved buffers
set hidden

" Fix backspace behavior
set backspace=2

" Disable swap/backup files
set nobackup
set nowritebackup
set noswapfile

" Disable matchparen plugin (avoid glitchy behavior)
let g:loaded_matchparen = 1  " or use `:NoMatchParen`

" Automatically cd to directory of opened file
set autochdir

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
" Source Additional Files (Plugins, Settings, etc.)
"------------------------------------------------------------------------------
call lib#SourceIfExists('$HOME/.vim/plugin_loader.vim')
call plugin_loader#PlugInit()
call settings#LoadSettings()
call lib#SourceIfExists('$HOME/.vim/settings/highlight.vim')

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
call lib#SourceIfExists('$HOME/.vimrc.local')