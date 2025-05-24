# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a minimalist, modular Vim configuration designed for sustainability and portability. The configuration follows a philosophy of simplicity and reliability, with conditional loading to prevent breakage when dependencies are missing.

## Key Architecture

### Entry Points
- `vimrc`: Main configuration entry that orchestrates all other components
- `plugin_loader.vim`: Bootstraps vim-plug and handles automatic plugin installation
- `plugins.vim`: Defines all plugins with conditional loading based on executable availability

### Directory Structure
- `autoload/`: Core functions (settings.vim, lib.vim)
- `settings/`: Modular configuration files loaded by autoload/settings.vim
- `ftplugin/`: File-type specific settings
- `plugged/`: Plugin installation directory (gitignored)
- `coc-settings.json`: Language server configurations for CoC.nvim

### Plugin Management
Uses vim-plug with automatic installation. Plugins are conditionally loaded based on executable availability (e.g., rust.vim only loads if `cargo` exists).

## Common Commands

### Plugin Management
```vim
:PlugInstall    " Install missing plugins
:PlugUpdate     " Update all plugins
:PlugClean      " Remove unused plugins
```

### Build/Maintenance
```bash
make nvim       # Set up Neovim compatibility symlinks
make vint       # Lint vim configuration files
make complete   # Link contrib files for completion
```

### Testing Changes
When modifying configuration:
1. Source the file: `:source %` or `:source ~/.vim/vimrc`
2. Check for errors: `:messages`
3. Test conditional loading by checking executable availability

## Key Design Patterns

### Conditional Loading
Plugins and settings are loaded conditionally based on:
- Executable availability: `if executable('cargo')`
- Vim version: `if v:version >= 704`
- Platform detection: Uses `lib#platform#*()` functions

### Modular Settings
Settings are split into files under `settings/` and loaded by `autoload/settings.vim`. This allows for organized, maintainable configuration.

### LSP Configuration
Language servers are configured in `coc-settings.json` with format-on-save enabled for multiple languages. The configuration includes extensive setups for Python, TypeScript, Rust, and other languages.

### FZF Integration
Custom FZF commands are defined in `autoload/settings.vim` with AG (silver searcher) integration for fast project-wide searching.

## Important Conventions

1. **Leader key**: Comma (,) is used as the leader key
2. **Clipboard**: System clipboard integration is enabled by default
3. **Root detection**: vim-rooter automatically changes to project root
4. **Color schemes**: Falls back through multiple schemes if primary is unavailable
5. **Session storage**: Sessions are stored in `~/.cache/vim/sessions/`

## Adding New Features

### New Plugin
Add to `plugins.vim` with appropriate conditional:
```vim
if executable('required-binary')
  Plug 'author/plugin-name'
endif
```

### New Key Mapping
Add to `settings/keymappings.vim` or create a new file in `settings/`.

### New Language Support
1. Add language server config to `coc-settings.json`
2. Create ftplugin file if needed: `ftplugin/<filetype>.vim`
3. Add any required plugins to `plugins.vim`