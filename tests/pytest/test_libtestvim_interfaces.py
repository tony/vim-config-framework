from __future__ import annotations

import asyncio
from collections.abc import Awaitable
from dataclasses import is_dataclass
from pathlib import Path

import pytest

from libtestvim import HistoryEntry, RunResult, json_schema, to_jsonl
from libtestvim.cli import main
from libtestvim.mcp_server import build_mcp_server
from libtestvim.models import (
    BenchmarkReport,
    BenchmarkScenarioResult,
    CapabilityReport,
    EnvironmentReport,
    GitRepoState,
)
from libtestvim.serde import from_json


def run_async(coro: Awaitable[None]) -> None:
    return asyncio.run(coro)


def _make_benchmark_report(*scenarios: tuple[str, float]) -> BenchmarkReport:
    cap = CapabilityReport(
        vim_bin="vim",
        version_line="VIM 9.1",
        version_output="",
        feature_flags=(),
        supports_profile=False,
        supports_channel_log=False,
        supports_startuptime=False,
        supports_getscriptinfo=False,
    )
    env = EnvironmentReport(
        repo_root=Path("."),
        vimrc_path=Path("vimrc"),
        plugin_root=None,
        fzf_root=None,
        artifact_root=Path("."),
        fixture_root=None,
        tools=(),
        git=GitRepoState(root=Path("."), branch="main", commit="abc", is_dirty=False),
    )
    return BenchmarkReport(
        version=1,
        run_id="test",
        generated_at="2026-01-01T00:00:00+00:00",
        label="test",
        capability=cap,
        environment=env,
        plugin_manifest=(),
        scenarios=tuple(
            BenchmarkScenarioResult(
                name=name,
                command="vim",
                mean_seconds=mean,
                min_seconds=mean,
                max_seconds=mean,
            )
            for name, mean in scenarios
        ),
    )


def test_history_entry_jsonl_round_trip() -> None:
    entry = HistoryEntry(
        run_id="run-1",
        label="baseline",
        scenario="empty_startup",
        generated_at="2026-03-13T00:00:00+00:00",
        branch="main",
        commit="deadbeef",
        vim_bin="vim",
        vim_version="VIM 9.1",
        mean_seconds=0.1,
        min_seconds=0.09,
        max_seconds=0.11,
    )
    payload = to_jsonl([entry])
    round_tripped = from_json(HistoryEntry, payload.splitlines()[0])
    assert round_tripped.scenario == entry.scenario
    assert round_tripped.commit == entry.commit


def test_cli_schema_command_emits_json(capsys) -> None:
    exit_code = main(["schema", "run-result"])
    captured = capsys.readouterr().out
    assert exit_code == 0
    assert '"type": "object"' in captured


def test_mcp_server_builds(vim_harness) -> None:
    pytest.importorskip("fastmcp")
    server = build_mcp_server(vim_harness)
    assert server is not None


def test_mcp_tool_schemas_and_resources(vim_harness) -> None:
    fastmcp = pytest.importorskip("fastmcp")

    async def scenario() -> None:
        async with fastmcp.Client(build_mcp_server(vim_harness)) as client:
            tools = {tool.name: tool for tool in await client.list_tools()}
            assert {"probe_vim", "run_vim", "benchmark_vim", "compare_refs", "compare_multi_refs"} <= tools.keys()

            probe_tool = tools["probe_vim"]
            assert probe_tool.outputSchema is not None
            assert probe_tool.outputSchema["type"] == "object"
            assert probe_tool.annotations is not None
            assert probe_tool.annotations.readOnlyHint is True

            for name in ("run_vim", "benchmark_vim", "compare_refs"):
                assert tools[name].outputSchema is not None
                assert tools[name].outputSchema["type"] == "object"

            probe = await client.call_tool("probe_vim", {})
            assert probe.is_error is False
            assert probe.structured_content is not None
            assert is_dataclass(probe.data)
            assert probe.data.vim_bin == vim_harness.spec.vim_bin

            run_result = await client.call_tool("run_vim", {"emit_bundle": True})
            assert run_result.is_error is False
            assert run_result.structured_content is not None
            assert is_dataclass(run_result.data)
            assert run_result.data.command.returncode == 0
            assert run_result.data.artifact_bundle is not None

            run_id = run_result.data.artifact_bundle.run_id
            run_contents = await client.read_resource(f"testvim://runs/{run_id}/summary")
            assert len(run_contents) == 1
            assert run_contents[0].mimeType == "application/json"
            run_summary = from_json(RunResult, run_contents[0].text)
            assert run_summary.command.returncode == 0

            latest_contents = await client.read_resource("testvim://runs/latest/summary")
            assert len(latest_contents) == 1
            latest_run = from_json(RunResult, latest_contents[0].text)
            assert latest_run.command.shell_command == run_summary.command.shell_command

            with pytest.raises(Exception, match="run summary"):
                await client.read_resource("testvim://runs/does-not-exist/summary")

    run_async(scenario())


@pytest.mark.benchmark
def test_mcp_benchmark_tools_and_history_resource(vim_harness) -> None:
    fastmcp = pytest.importorskip("fastmcp")

    async def scenario() -> None:
        async with fastmcp.Client(build_mcp_server(vim_harness)) as client:
            benchmark = await client.call_tool(
                "benchmark_vim",
                {"label": "pytest-mcp-benchmark", "emit_bundle": True},
            )
            assert benchmark.is_error is False
            assert benchmark.structured_content is not None
            assert is_dataclass(benchmark.data)
            assert len(benchmark.data.scenarios) == 5

            history_contents = await client.read_resource("testvim://history/benchmarks")
            assert len(history_contents) == 1
            assert history_contents[0].mimeType == "application/x-ndjson"
            history_lines = [line for line in history_contents[0].text.splitlines() if line.strip()]
            assert history_lines
            latest_history = from_json(HistoryEntry, history_lines[-1])
            assert latest_history.label == "pytest-mcp-benchmark"

            compare = await client.call_tool(
                "compare_refs",
                {
                    "base_ref": "HEAD",
                    "target_ref": "HEAD",
                    "emit_bundle": True,
                    "run_correctness": False,
                },
            )
            assert compare.is_error is False
            assert compare.structured_content is not None
            assert is_dataclass(compare.data)
            assert len(compare.data.scenarios) == 5

    run_async(scenario())


def test_compute_deltas_classifies_scenarios(vim_harness) -> None:
    base = _make_benchmark_report(("fast", 0.100), ("slow", 0.200), ("same", 0.150))
    target = _make_benchmark_report(("fast", 0.080), ("slow", 0.220), ("same", 0.152))

    deltas = vim_harness._compute_deltas(base, target)

    assert len(deltas) == 3
    by_name = {d.name: d for d in deltas}

    assert by_name["fast"].classification == "faster"
    assert by_name["fast"].percent_delta < -5

    assert by_name["slow"].classification == "slower"
    assert by_name["slow"].percent_delta > 5

    assert by_name["same"].classification == "noise"
    assert abs(by_name["same"].percent_delta) < 5


def test_compute_deltas_zero_base_mean(vim_harness) -> None:
    base = _make_benchmark_report(("zero_base", 0.0), ("both_zero", 0.0))
    target = _make_benchmark_report(("zero_base", 0.050), ("both_zero", 0.0))

    deltas = vim_harness._compute_deltas(base, target)

    by_name = {d.name: d for d in deltas}
    assert by_name["zero_base"].percent_delta == float("inf")
    assert by_name["zero_base"].classification == "slower"
    assert by_name["both_zero"].percent_delta == 0.0
    assert by_name["both_zero"].classification == "noise"


def test_compute_deltas_mismatched_scenarios(vim_harness) -> None:
    base = _make_benchmark_report(("shared", 0.100))
    target = _make_benchmark_report(("shared", 0.105), ("extra", 0.200))

    deltas = vim_harness._compute_deltas(base, target)

    assert len(deltas) == 1
    assert deltas[0].name == "shared"


def test_run_result_schema_is_object() -> None:
    schema = json_schema(RunResult)
    assert isinstance(schema, dict)
