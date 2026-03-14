alias t := test

set unstable

pytest := "env -u VIRTUAL_ENV uv run --group test pytest"
testvim := "env -u VIRTUAL_ENV uv run --group test testvim"

[private]
default:
  @just --justfile {{justfile()}} --list --unsorted

[doc("List available recipes grouped by purpose.")]
[group: 'meta']
list:
  @just --justfile {{justfile()}} --list --unsorted

[doc("List recipe groups.")]
[group: 'meta']
groups:
  @just --justfile {{justfile()}} --groups --unsorted

[doc("Probe the current Vim binary and print libtestvim capability JSON.")]
[group: 'meta']
probe:
  {{testvim}} probe

[doc("Run ruff check and format verification.")]
[group: 'lint']
lint:
  env -u VIRTUAL_ENV uv run --group lint ruff check src tests
  env -u VIRTUAL_ENV uv run --group lint ruff format --check src tests

[doc("Run ty type checking on src/.")]
[group: 'lint']
typecheck:
  uvx ty check src/

[doc("Lint top-level Vimscript files with vint.")]
[group: 'lint']
vint:
  env -u VIRTUAL_ENV PYTHONWARNINGS='ignore:pkg_resources is deprecated as an API:UserWarning' uvx --python 3.13 --with vim-vint --with 'setuptools<81' vint *.vim

[doc("Create or update the uv-managed test environment.")]
[group: 'setup']
sync:
  env -u VIRTUAL_ENV uv sync --group test

[doc("Install vim-plug plugins into the hermetic plugged/ directory.")]
[group: 'setup']
plug-install:
  {{testvim}} run --cmd 'PlugInstall | qa'

[doc("Link this Vim config into Neovim's config directory.")]
[group: 'setup']
nvim:
  ln -sf ~/.vim/autoload/ ~/.config/nvim/
  ln -sf ~/.vim/vimrc ~/.config/nvim/init.vim
  ln -sf ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json

[doc("Link contrib snippets into the local settings directories.")]
[group: 'setup']
complete:
  ln -sf ~/.vim/plugins.settings/contrib/*.vim ~/.vim/plugins.settings/
  ln -sf ~/.vim/settings/contrib/*.vim ~/.vim/settings/

[doc("Run the fast hermetic suites without tmux or benchmarks.")]
[group: 'test']
test:
  {{pytest}} -q -m "not tmux and not benchmark"

[doc("Run the native Vimscript core suites only.")]
[group: 'test']
test-core:
  {{pytest}} -q -m core

[doc("Run the plugin and executable integration suites.")]
[group: 'test']
test-integration:
  {{pytest}} -q -m integration

[doc("Run the libtmux-backed terminal smoke test.")]
[group: 'test']
test-tmux:
  {{pytest}} -q -m tmux

[doc("Generate report-only startup benchmark artifacts.")]
[group: 'benchmark']
benchmark:
  {{testvim}} bench --emit-bundle --append-history

[doc("Compare the current branch against the remote default branch and write a compare bundle.")]
[group: 'benchmark']
compare:
  {{testvim}} compare --emit-bundle

[doc("Compare the current branch against multiple refs.")]
[group: 'benchmark']
compare-multi *refs:
  {{testvim}} compare-multi {{refs}}

[doc("Run the full pytest matrix, including tmux and benchmark jobs.")]
[group: 'test']
test-all:
  {{pytest}} -q

[doc("Serve libtestvim as a FastMCP server over stdio.")]
[group: 'meta']
serve-mcp:
  {{testvim}} serve-mcp
