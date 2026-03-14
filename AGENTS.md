# AGENTS.md

This file provides guidance to LLM Agents such as Codex, Gemini, Claude Code (claude.ai/code), etc. when working with code in this repository.

## CRITICAL REQUIREMENTS

### Test Success
- ALL tests MUST pass for code to be considered complete and working
- Never describe code as "working as expected" if there are ANY failing tests
- Even if specific feature tests pass, failing tests elsewhere indicate broken functionality
- Changes that break existing tests must be fixed before considering implementation complete
- A successful implementation must pass linting, type checking, AND all existing tests

## Project Overview

This is a minimalist, modular Vim configuration designed for sustainability and portability. The configuration follows a philosophy of simplicity and reliability, with conditional loading to prevent breakage when dependencies are missing. It includes `libtestvim`, a hermetic test harness and benchmark toolkit for validating the Vim configuration.

The project has a dual nature:
- **Vim configuration**: `vimrc`, `plugins.vim`, `autoload/`, `settings/`, `ftplugin/`
- **Python package** (`libtestvim`): hermetic Vim harnessing, profiling, and benchmarks under `src/libtestvim/`

## Development Environment

This project uses:
- Python 3.13+ (for `libtestvim`)
- [uv](https://github.com/astral-sh/uv) for dependency management
- [ruff](https://github.com/astral-sh/ruff) for linting and formatting
- [ty](https://github.com/astral-sh/ty) for type checking
- [pytest](https://docs.pytest.org/) for testing
- [just](https://github.com/casey/just) as the task runner
- [hyperfine](https://github.com/sharkdp/hyperfine) for startup benchmarks
- Vim 9.1+ (test target)

## Key Architecture

### Entry Points
- `vimrc`: Main configuration entry that orchestrates all other components (includes inline vim-plug bootstrap)
- `plugins.vim`: Defines all plugins with conditional loading based on executable availability

### Directory Structure
- `autoload/`: Core functions (settings.vim, lib.vim)
- `settings/`: Modular configuration files loaded by autoload/settings.vim
- `ftplugin/`: File-type specific settings
- `plugged/`: Plugin installation directory (gitignored)
- `coc-settings.json`: Language server configurations for CoC.nvim
- `src/libtestvim/`: Python package for hermetic Vim harnessing, profiling, and benchmarks
- `tests/vim/`: Native Vimscript test suites (core/ and integration/)
- `tests/pytest/`: Python test files driven by pytest
- `justfile`: Task runner recipes for setup, test, lint, and benchmark workflows

### Plugin Management
Uses vim-plug with automatic installation. Plugins are conditionally loaded based on executable availability (e.g., rust.vim only loads if `cargo` exists).

## Common Commands

### Plugin Management
```vim
:PlugInstall    " Install missing plugins
:PlugUpdate     " Update all plugins
:PlugClean      " Remove unused plugins
```

### Setup

Create or update the uv-managed test environment:

```bash
just sync
```

Install vim-plug plugins into the hermetic plugged/ directory:

```bash
just plug-install
```

Set up Neovim compatibility symlinks:

```bash
just nvim
```

Link contrib snippets into settings directories:

```bash
just complete
```

### Linting

Run ruff check and format verification:

```bash
just lint
```

Run ty type checking on src/:

```bash
just typecheck
```

Lint Vimscript files with vint:

```bash
just vint
```

### Testing

Run the fast hermetic suites (no tmux or benchmarks):

```bash
just test
```

Run native Vimscript core suites only:

```bash
just test-core
```

Run plugin and executable integration suites:

```bash
just test-integration
```

Run the libtmux-backed terminal smoke test:

```bash
just test-tmux
```

Run the full pytest matrix:

```bash
just test-all
```

### Benchmarking

Generate startup benchmark artifacts:

```bash
just benchmark
```

Compare the current branch against the remote default:

```bash
just compare
```

Compare the current branch against multiple refs:

```bash
just compare-multi
```

### Testing Changes
When modifying configuration:
1. Source the file: `:source %` or `:source ~/.vim/vimrc`
2. Check for errors: `:messages`
3. Test conditional loading by checking executable availability

## Development Workflow

Follow this workflow for code changes:

1. **Lint**: `just lint`
2. **Typecheck**: `just typecheck`
3. **Test**: `just test`
4. **Full matrix**: `just test-all`

## Testing Guidelines

### Dual Test Stack

This project has two test layers:

1. **Native Vimscript suites** (`tests/vim/core/`, `tests/vim/integration/`)
   - Use `Test_*` function naming
   - Use `SetUp()` / `TearDown()` for per-test fixtures
   - Assert with `v:errors` (`call assert_equal(...)`, `call assert_true(...)`)
   - Run in Vim's Ex mode via the test harness

2. **Python tests** (`tests/pytest/`)
   - Driven by pytest through `libtestvim`
   - Use `@pytest.mark.core`, `.integration`, `.tmux`, `.benchmark` markers
   - Available fixtures: `repo_root`, `artifact_root`, `vim_harness`, `vim_suite_runner`, `benchmark_spec`

### Testing Conventions

- **Functional tests only**: Write tests as standalone functions, not classes. Avoid `class TestFoo:` groupings.
- **Use existing fixtures** from `conftest.py` instead of `monkeypatch` and `MagicMock` when available.
- **Prefer `tmp_path`** (pathlib.Path) over Python's `tempfile`.

## Coding Standards

### Python (libtestvim)

- Use `from __future__ import annotations` at the top of all Python files
- Use namespace imports for stdlib: `import pathlib` not `from pathlib import Path`
- For typing, use `import typing as t` and access via namespace: `t.NamedTuple`, etc.
- Target Python 3.13+ features

### Vimscript

- Conditional loading based on executable availability: `if executable('cargo')`
- Version guards: `if v:version >= 704`
- Platform detection via `lib#platform#*()` functions

## Key Design Patterns

### Conditional Loading
Plugins and settings are loaded conditionally based on:
- Executable availability: `if executable('cargo')`
- Vim version: `if v:version >= 704`
- Platform detection: Uses `lib#platform#*()` functions

### Modular Settings
Settings are split into files under `settings/` and loaded by `autoload/settings.vim`. This allows for organized, maintainable configuration.

### Hermetic Test Mode
When `g:vim_test_mode` is set (by the test harness wrapper), the configuration uses isolated paths:
- `lib#ConfigRoot()` returns `g:vim_config_root` (the repo root) instead of `~/.vim`
- `lib#PluginRoot()` returns `g:vim_plugin_root` instead of `~/.vim/plugged`
- `g:vim_state_root` provides an isolated state directory
This allows tests to run in a clean temporary `$HOME` without affecting the user's real configuration.

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

## Git Commit Standards

Format commit messages as:

```
Scope(type[detail]): concise description

why: Explanation of necessity or impact.
what:
- Specific technical changes made
- Focused on a single topic
```

Line wrapping: wrap body lines at **72 characters**. Let URLs, file
paths, commit hashes, and long identifiers overflow rather than
breaking mid-token.

### Common Commit Types

- **feat**: New features or enhancements
- **fix**: Bug fixes
- **refactor**: Code restructuring without functional change
- **docs**: Documentation updates
- **chore**: Maintenance (dependencies, tooling, config)
- **test**: Test-related updates
- **style**: Code style and formatting
- **ai(rules[AGENTS])**: AI rule updates (AGENTS.md)
- **ai(claude[rules])**: Claude Code rules (CLAUDE.md)

### Project-Specific Scopes

- `vim(type[detail])` -- Vim config changes (vimrc, plugins, settings, autoload, ftplugin)
- `harness(type[detail])` -- libtestvim Python package (src/libtestvim/)
- `tests(type[detail])` -- test suites and fixtures
- `ci(type[detail])` -- CI/GitHub Actions

Examples:

```
vim(feat[plugins]): Add conditional loading for rust.vim

why: Only load rust.vim when cargo is available
what:
- Wrap rust.vim Plug call in executable('cargo') guard
- Add rustfmt-on-save setting in ftplugin/rust.vim
```

```
harness(fix[VimHarness]): Fix hermetic HOME isolation on macOS

why: macOS temp dirs resolve through /private symlink
what:
- Resolve tmp_path with Path.resolve() before setting HOME
- Add regression test for symlinked temp directories
```

```
tests(refactor[core]): Split options suite into focused files

why: options_and_mappings.vim grew too large to maintain
what:
- Extract mapping tests to core/keymappings.vim
- Extract option tests to core/global_options.vim
- Update runner.vim to source both new files
```

### Version and Dependency Bumps

Single package:

```
scope(tool) old_version -> new_version

See also:
- https://github.com/owner/repo/releases/tag/vX.Y.Z
- https://github.com/owner/repo/blob/vX.Y.Z/CHANGELOG.md
```

Multiple packages:

```
scope(chore) Bump tool1, tool2

- tool1 1.2.0 -> 1.3.0
  - https://github.com/owner/tool1/releases/tag/v1.3.0
- tool2 0.9.1 -> 0.10.0
  - https://github.com/owner/tool2/releases/tag/v0.10.0
```

### Commit Quality Checklist

**Do:**
- Research the CHANGELOG/release notes before writing version bump commits
- Use the `why:`/`what:` body format for non-trivial changes
- Keep the subject line concise (aim for under 72 characters)
- Use imperative mood in the subject: "Add", "Fix", "Update"

**Don't:**
- Combine unrelated changes in one commit
- Write vague subjects like "Fix bug" or "Update code"
- Skip the `why:` when the reason isn't obvious from the diff
- Include generated files (plugged/, __pycache__) in commits

### Multi-line Commits

Use heredoc to preserve formatting:

```bash
git commit -m "$(cat <<'EOF'
vim(feat[settings]): Add treesitter highlighting toggle

why: Allow quick fallback to regex highlighting for large files
what:
- Add <leader>th mapping to toggle treesitter
- Store preference in g:vim_treesitter_enabled
EOF
)"
```

## Documentation Standards

### Code Blocks in Documentation

When writing documentation (README, CHANGES, docs/), follow these rules for code blocks:

**One command per code block.** This makes commands individually copyable.

**Put explanations outside the code block**, not as comments inside.

Good:

Run the tests:

```console
$ just test
```

Run with the full matrix:

```console
$ just test-all
```

Bad:

```console
# Run the tests
$ just test

# Run with the full matrix
$ just test-all
```

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

## Debugging Tips

When stuck in debugging loops:

1. **Pause and acknowledge the loop**
2. **Minimize to MVP**: Remove all debugging cruft and experimental code
3. **Document the issue** comprehensively for a fresh approach
4. **Format for portability** (using quadruple backticks)
