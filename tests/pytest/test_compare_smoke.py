from __future__ import annotations

import shutil
import subprocess
from dataclasses import replace
from pathlib import Path

import pytest

from libtestvim import CompareSpec, MultiCompareReport
from libtestvim.gitmeta import detect_origin_default_ref


def _worktree_roots(repo_root: Path) -> set[str]:
    completed = subprocess.run(
        ["git", "-C", str(repo_root), "worktree", "list", "--porcelain"],
        capture_output=True,
        text=True,
        check=False,
    )
    if completed.returncode != 0:
        raise RuntimeError(completed.stderr or completed.stdout or "Failed to list git worktrees")

    return {line.removeprefix("worktree ") for line in completed.stdout.splitlines() if line.startswith("worktree ")}


@pytest.mark.benchmark
def test_compare_default_ref_runs_correctness_and_cleans_up_worktrees(
    repo_root: Path,
    vim_harness,
) -> None:
    if shutil.which(vim_harness.spec.hyperfine_bin) is None:
        pytest.skip("hyperfine is not installed")

    base_ref = detect_origin_default_ref(repo_root)
    if base_ref is None:
        pytest.skip("origin default ref is not configured")

    benchmark = replace(
        vim_harness.default_benchmark_spec(
            label="compare-smoke",
            emit_bundle=True,
            append_history=False,
        ),
        warmup_runs=0,
        timed_runs=1,
    )
    worktrees_before = _worktree_roots(repo_root)

    report = vim_harness.compare(
        CompareSpec(
            base_ref=base_ref,
            target_ref="HEAD",
            emit_bundle=True,
            benchmark=benchmark,
        )
    )

    worktrees_after = _worktree_roots(repo_root)

    assert report.base_correctness_ok
    assert report.target_correctness_ok
    # base_suites may be None when the base ref predates tests/vim/
    if report.base_suites is not None:
        assert report.base_suites.ok
    if report.target_suites is not None:
        assert report.target_suites.ok
    assert report.base_benchmark is not None
    assert report.target_benchmark is not None
    assert len(report.scenarios) == 5
    assert report.artifact_bundle is not None
    assert report.artifact_bundle.root.is_relative_to(vim_harness.spec.artifact_root)
    assert not report.artifact_bundle.root.is_relative_to(repo_root / "artifacts" / "vim")
    assert (report.artifact_bundle.root / "compare.json").is_file()
    assert worktrees_after == worktrees_before


@pytest.mark.benchmark
def test_compare_multi_two_refs_produces_pairwise_report(
    repo_root: Path,
    vim_harness,
) -> None:
    if shutil.which(vim_harness.spec.hyperfine_bin) is None:
        pytest.skip("hyperfine is not installed")

    benchmark = replace(
        vim_harness.default_benchmark_spec(
            label="compare-multi-smoke",
            emit_bundle=True,
            append_history=False,
        ),
        warmup_runs=0,
        timed_runs=1,
    )
    worktrees_before = _worktree_roots(repo_root)

    report = vim_harness.compare_multi(
        ("HEAD", "HEAD"),
        CompareSpec(
            emit_bundle=True,
            run_correctness=False,
            benchmark=benchmark,
        ),
    )

    worktrees_after = _worktree_roots(repo_root)

    assert isinstance(report, MultiCompareReport)
    assert report.refs == ("HEAD", "HEAD")
    assert len(report.commits) == 2
    assert len(report.pairwise) == 1
    pair = report.pairwise[0]
    assert pair.base_ref == "HEAD"
    assert pair.target_ref == "HEAD"
    assert len(pair.scenarios) == 5
    for delta in pair.scenarios:
        assert delta.percent_delta != float("nan"), f"unexpected NaN delta for {delta.name}"
    assert report.artifact_bundle is not None
    assert (report.artifact_bundle.root / "multi-compare.json").is_file()
    assert worktrees_after == worktrees_before
