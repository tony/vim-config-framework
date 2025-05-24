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
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_list_window_size = 5
let g:ale_lint_on_enter = 0

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
" Color Schemes - Fallback Logic
"------------------------------------------------------------------------------
" Using an assumed function lib#ColorSchemeExists() to check if a scheme is present

if has('nvim') && exists('*lib#ColorSchemeExists') && lib#ColorSchemeExists('tokyonight-moon')
  colorscheme tokyonight-moon
elseif exists('*lib#ColorSchemeExists') && lib#ColorSchemeExists('tokyonight')
  colorscheme tokyonight
elseif exists('*lib#ColorSchemeExists') && lib#ColorSchemeExists('catppuccin_mocha')
  colorscheme catppuccin_mocha
elseif exists('*lib#ColorSchemeExists') && lib#ColorSchemeExists('gruvbox')
  colorscheme gruvbox
elseif exists('*lib#ColorSchemeExists') && lib#ColorSchemeExists('gruvbox-material')
  let g:gruvbox_material_disable_italic_comment = 1
  colorscheme gruvbox-material
elseif exists('*lib#ColorSchemeExists') && lib#ColorSchemeExists('everforest')
  if has('termguicolors')
    set termguicolors
  endif
  set background=dark
  let g:everforest_background = 'hard'
  let g:everforest_transparent_background = 2
  let g:everforest_disable_italic_comment = 1
  colorscheme everforest
elseif exists('*lib#ColorSchemeExists') && lib#ColorSchemeExists('desert-warm-256')
  colorscheme desert-warm-256
else
  colorscheme desert
endif

"------------------------------------------------------------------------------
" Local Customizations
"------------------------------------------------------------------------------
call lib#SourceIfExists('$HOME/.vimrc.local')