vint:
	python -c 'import vint' || pip install --user vim-vint
	vint *.vim

nvim:
	ln -sf ~/.vim/autoload/ ~/.config/nvim/
	ln -sf ~/.vim/.vimrc ~/.config/nvim/init.vim
	ln -sf ~/.vim/coc-settings.json ~/.config/nvim/coc-settings.json

complete:
	ln -sf ~/.vim/plugins.settings/contrib/*.vim ~/.vim/plugins.settings/
	ln -sf ~/.vim/settings/contrib/*.vim ~/.vim/settings/

test:
	@echo "Running Vim configuration tests..."
	@vim -Es -u tests/harness.vim -c "source tests/basic.vim" 2>&1 | grep -E '(PASS|FAIL|INFO)' || true
	@echo "Tests completed"

test-simplification:
	@echo "Testing simplification opportunities..."
	@vim -Es -u tests/harness.vim -c "source tests/simplification.vim" 2>&1 | grep -E '(PASS|FAIL|INFO)' || true

test-verbose:
	@vim -Es -u tests/harness.vim -c "source tests/basic.vim" 2>&1 || true

test-startup:
	@echo "Testing Vim startup time..."
	@vim --startuptime /tmp/vim-startup.log -c quit
	@echo "=== Slowest operations ==="
	@sort -k2 -nr /tmp/vim-startup.log | head -20

test-minimal:
	@echo "Testing minimal config (no plugins)..."
	@vim -u NONE -Es -c "source tests/harness.vim" -c "source tests/basic.vim" 2>&1 || true

.PHONY: vint nvim complete test test-simplification test-verbose test-startup test-minimal
