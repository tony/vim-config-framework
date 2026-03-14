# Lessons from having a complex vim config: don't do it

It's a time sink.

Having the vim configuration break all the time, and pasting in "nice to have" stuff has caused me
more disruption / harm than it has benefitted me. I'm trying to turn my VIM into a lean editing
system, and just learning plain-old VIM more effectively.

If you want to go back to where I used to be to look feel free to see:
<https://github.com/tony/vim-config-framework/tree/2018-06-09>

I'm hoping to have a happier, healthier VIM experience, life, etc. with a simple vim config.

## Plugin Architecture

This configuration implements an auto-installing, gracefully degrading plugin system built on vim-plug:

- **Auto-Installation**: Automatically bootstraps vim-plug and installs plugins on first run
- **Graceful Degradation**: Conditionally loads plugins based on available executables and features
- **Modular Design**: Supports local customizations through `plugins.d/` and `plugins.settings/` directories
- **Progressive Enhancement**: Basic functionality always works, advanced features added when dependencies exist

## Testing

The repo now exposes its hermetic Vim harness as the installable `libtestvim` package under `src/libtestvim`, with grouped `just` recipes as the main entrypoint:

- `just sync` installs the project and test dependencies via `uv`
- `just` lists recipes grouped by purpose
- `just probe` prints the current Vim capability report
- `just test` runs the fast hermetic suites
- `just test-tmux` runs the `libtmux` terminal smoke test on its own socket
- `just benchmark` runs `testvim bench --emit-bundle --append-history`
- `just compare` benchmarks the current branch against the remote default branch
- `just compare-multi` compares the current branch against multiple refs
- `just serve-mcp` serves `libtestvim` as a FastMCP server over stdio
- GitHub Actions runs the merge-gate verification path with `just probe`, `just vint`, `just test-all`, `just benchmark`, and `just compare`
- the repo vendors `autoload/plug.vim` so the harness works from a clean checkout and in CI without relying on prior local bootstrap state

`libtestvim` can be used three ways:

- as a Python API returning dataclasses with Pydantic-backed JSON and JSONL helpers
- as the `testvim` CLI for probing, running, benchmarking, and comparing configs
- as a FastMCP server exposing benchmark and comparison tools plus artifact resources

Python dependencies are managed by `uv`. System tools like `vim`, `tmux`, and `hyperfine` remain external prerequisites.

See [tests/README.md](tests/README.md) for the suite layout, artifact model, and fixture corpus.

Please check out:

- <https://www.reddit.com/r/vim/wiki/vimrctips>
- <https://www.reddit.com/r/vim/wiki/10th_rule>
- <https://www.reddit.com/r/vim/wiki/norc>
- <https://www.vi-improved.org/recommendations/>

## License

MIT

Vendorizes sensible.vim and vim-plug. `autoload/plug.vim` retains the upstream MIT license header.

[license permission]: https://github.com/tpope/vim-sensible/issues/106
