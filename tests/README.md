# Vim Configuration Test Suite

This directory contains tests for validating the Vim configuration.

## Available Tests

### Basic Tests
```bash
make test              # Run basic configuration tests
make test-verbose      # Show full test output
```

### Analysis Tests
```bash
make test-simplification  # Analyze simplification opportunities
make test-startup        # Profile startup time
make test-minimal        # Test without plugins
```

### Linting
```bash
make vint               # Lint Vim files (requires vim-vint)
```

## Test Files

- `harness.vim` - Test framework with assertion helpers
- `basic.vim` - Basic configuration validation
- `simplification.vim` - Validates simplification opportunities

## Running Tests

The tests use Vim in Ex mode (`-Es`) for headless execution. All tests are designed to:
1. Load the configuration
2. Validate expected behavior
3. Exit with appropriate status

## Adding New Tests

1. Create a new test file in `tests/`
2. Use the test harness functions:
   - `TestAssert(condition, message)`
   - `TestExists(item, type, message)`
3. Add a new make target if needed

## Test Results

From the startup time analysis, the slowest operations are:
1. Warning delay (2009ms) - First-time plugin installation warning
2. Loading vimrc (146ms)
3. Loading plugins.vim (127ms)
4. NERDTree plugin (35ms)

This confirms that the auto-installing plugin system works but has an initial delay on first run.