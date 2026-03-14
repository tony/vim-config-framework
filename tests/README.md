# Vim Configuration Test Suite

This directory contains the repo-facing tests and fixtures for `libtestvim`.

## Layout

- `pytest/` exercises the public `libtestvim` package against this repo's Vim config
- `fixtures/` provides stable benchmark inputs for Python, TypeScript, Markdown, and Vim
- `vim/` contains the native Vimscript runner and `Test_*` suites

## Commands

```bash
just                  # List recipes grouped by purpose
just groups           # List recipe groups only
just sync             # Install Python test dependencies with uv
just probe            # Print the current libtestvim capability report
just test             # Fast hermetic suites, no tmux or benchmarks
just test-core        # Native core Vimscript suites only
just test-integration # Plugin/executable integration suites
just test-tmux        # libtmux-backed terminal smoke test
just benchmark        # Generate libtestvim benchmark artifacts and append JSONL history
just compare          # Compare this branch against the remote default branch
just compare-multi    # Compare current branch against multiple refs
just serve-mcp        # Serve libtestvim over stdio via FastMCP
```

GitHub Actions uses the merge-gate path: `just probe`, `just vint`, `just test-all`, `just benchmark`, and `just compare`.

## Harness Model

- The library bootstraps Vim into a disposable HOME/XDG/state tree for every run and sources this repo's `vimrc` through a generated wrapper.
- Run `just sync` once before the recipes so `pytest`, `fastmcp`, and `libtmux` come from the repo's `uv` environment.
- The Vim config runs in `g:vim_test_mode`, which redirects stateful paths and disables startup side effects such as `PlugInstall`, `xrdb -load`, and CoC extension installation.
- Core and integration suites still run one Vimscript suite per fresh Vim process through `tests/vim/runner.vim`, but the pytest layer now calls the public `libtestvim` package instead of reimplementing the runner.
- Tmux smoke coverage uses `libtestvim.tmux` plus `libtmux` context managers on a dedicated socket.
- Pytest runs use disposable artifact roots so benchmark and compare tests do not rewrite the repo's artifact directories.
- User-invoked benchmark recipes emit a run bundle under `artifacts/vim/runs/` and can append scenario-level history to `artifacts/vim/history.jsonl`.
- Compare runs emit branch-to-branch reports under `artifacts/vim/compare/`.
- `tmux` and `hyperfine` remain system dependencies; `uv` manages the Python side of the harness.

## Adding Suites

- Add Vimscript assertions under `tests/vim/core/` or `tests/vim/integration/` as `Test_*` functions.
- Use helpers from `tests/vim/helpers.vim` for temp files, cleanup, and common assertions.
- Add or update a pytest test only when the suite needs new orchestration behavior, a real terminal, or benchmark reporting.
