from __future__ import annotations

from collections.abc import Callable
from pathlib import Path

import pytest

from libtestvim import BenchmarkSpec, VimHarness
from libtestvim.models import SuiteResult

REPO_ROOT = Path(__file__).resolve().parents[2]


@pytest.fixture(scope="session")
def repo_root() -> Path:
    return REPO_ROOT


@pytest.fixture(scope="session")
def artifact_root(tmp_path_factory: pytest.TempPathFactory) -> Path:
    return tmp_path_factory.mktemp("libtestvim-artifacts")


@pytest.fixture(scope="session")
def vim_harness(repo_root: Path, artifact_root: Path) -> VimHarness:
    return VimHarness.from_repo(repo_root, artifact_root=artifact_root)


@pytest.fixture
def vim_suite_runner(vim_harness: VimHarness) -> Callable[[Path], SuiteResult]:
    return vim_harness.run_suite


@pytest.fixture
def benchmark_spec(vim_harness: VimHarness) -> BenchmarkSpec:
    return vim_harness.default_benchmark_spec(
        label="pytest-benchmark",
        emit_bundle=True,
        append_history=False,
    )
