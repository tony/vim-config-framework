from __future__ import annotations

from pathlib import Path

import pytest

CORE_SUITES = [
    "core/startup_and_registration.vim",
    "core/options_and_mappings.vim",
    "core/filetypes_and_autocmds.vim",
]

INTEGRATION_SUITES = [
    "integration/project_root_and_local_commands.vim",
    "integration/gated_plugins.vim",
]


@pytest.mark.core
@pytest.mark.parametrize("suite_name", CORE_SUITES, ids=lambda value: Path(value).stem)
def test_core_vim_suite(repo_root: Path, vim_suite_runner, suite_name: str) -> None:
    result = vim_suite_runner(repo_root / "tests" / "vim" / suite_name)
    assert result.ok, result.render_failure()


@pytest.mark.integration
@pytest.mark.parametrize("suite_name", INTEGRATION_SUITES, ids=lambda value: Path(value).stem)
def test_integration_vim_suite(repo_root: Path, vim_suite_runner, suite_name: str) -> None:
    result = vim_suite_runner(repo_root / "tests" / "vim" / suite_name)
    assert result.ok, result.render_failure()
