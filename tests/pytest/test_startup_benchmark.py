from __future__ import annotations

import json
import shutil
from pathlib import Path

import pytest

from libtestvim import BenchmarkReport, HistoryEntry
from libtestvim.serde import from_json, json_schema


@pytest.mark.benchmark
def test_startup_benchmarks_emit_artifacts(
    repo_root: Path,
    vim_harness,
    benchmark_spec,
) -> None:
    if shutil.which(vim_harness.spec.hyperfine_bin) is None:
        pytest.skip("hyperfine is not installed")

    report = vim_harness.benchmark(benchmark_spec)
    assert isinstance(report, BenchmarkReport)
    assert len(report.scenarios) == 5
    assert report.artifact_bundle is not None

    bundle_root = report.artifact_bundle.root
    assert (bundle_root / "summary.json").is_file()
    assert (bundle_root / "hyperfine.json").is_file()
    assert (bundle_root / "environment.json").is_file()
    assert (bundle_root / "plugin-manifest.json").is_file()

    summary = from_json(BenchmarkReport, (bundle_root / "summary.json").read_text(encoding="utf-8"))
    assert summary.version == 1
    assert len(summary.scenarios) == 5

    raw_hyperfine = json.loads((bundle_root / "hyperfine.json").read_text(encoding="utf-8"))
    assert len(raw_hyperfine["results"]) == 5

    assert vim_harness.spec.artifact_root != repo_root / "artifacts" / "vim"

    for scenario in report.scenarios:
        assert scenario.mean_seconds > 0
        assert scenario.startuptime is not None
        assert scenario.scriptinfo is not None
        assert scenario.profile is not None

    history_schema = json_schema(HistoryEntry)
    assert history_schema["type"] == "object"
