from dataclasses import replace
from pathlib import Path
from typing import TypeVar

from libtestvim.harness import VimHarness
from libtestvim.models import BenchmarkReport, CapabilityReport, CompareReport, HistoryEntry, MultiCompareReport, RunResult
from libtestvim.serde import from_json
from libtestvim.specs import CompareSpec, InvocationSpec, TelemetrySpec

ValidatedT = TypeVar("ValidatedT")


def build_mcp_server(default_harness: VimHarness | None = None):
    try:
        from fastmcp import FastMCP
        from fastmcp.resources import ResourceContent, ResourceResult
    except ImportError as exc:  # pragma: no cover - exercised in integration environments
        raise RuntimeError("Install libtestvim with the mcp extra or run `uv sync --group test` to use the MCP server.") from exc

    mcp = FastMCP("libtestvim")

    def harness_for(repo_root: str | None, vim_bin: str | None) -> VimHarness:
        if repo_root is None and vim_bin is None and default_harness is not None:
            return default_harness
        if default_harness is not None:
            return VimHarness(
                replace(
                    default_harness.spec,
                    repo_root=Path(repo_root) if repo_root else default_harness.spec.repo_root,
                    vim_bin=vim_bin or default_harness.spec.vim_bin,
                )
            )
        return VimHarness.from_repo(repo_root or ".", vim_bin=vim_bin or "vim")

    def resource_harness() -> VimHarness:
        return harness_for(None, None)

    def load_json(path: Path, *, description: str) -> str:
        if not path.exists():
            raise FileNotFoundError(f"{description} not found at {path}")
        return path.read_text(encoding="utf-8")

    def validate_jsonl(path: Path, type_: type[ValidatedT], *, description: str) -> str:
        if not path.exists():
            raise FileNotFoundError(f"{description} not found at {path}")
        payload = path.read_text(encoding="utf-8")
        lines = tuple(line for line in payload.splitlines() if line.strip())
        if not lines:
            raise FileNotFoundError(f"{description} is empty at {path}")
        for line in lines:
            from_json(type_, line)
        return payload

    def latest_run_json(runs_root: Path) -> Path:
        run_files = sorted(runs_root.glob("*/run.json"), key=lambda path: path.stat().st_mtime, reverse=True)
        if not run_files:
            raise FileNotFoundError(f"No run artifacts found under {runs_root}")
        return run_files[0]

    def json_resource(payload: str, *, mime_type: str) -> ResourceResult:
        return ResourceResult([ResourceContent(payload, mime_type=mime_type)])

    @mcp.tool(
        annotations={
            "readOnlyHint": True,
            "idempotentHint": True,
            "openWorldHint": False,
        }
    )
    def probe_vim(repo_root: str | None = None, vim_bin: str | None = None) -> CapabilityReport:
        """Probe the selected Vim binary and report libtestvim capabilities."""
        return harness_for(repo_root, vim_bin).probe()

    @mcp.tool
    def run_vim(
        repo_root: str | None = None,
        vim_bin: str | None = None,
        file: str | None = None,
        commands: list[str] | None = None,
        emit_bundle: bool = False,
        startuptime: bool = False,
        scriptinfo: bool = False,
        profile: bool = False,
        verbose: bool = False,
        channel_log: bool = False,
    ) -> RunResult:
        """Run Vim hermetically once with optional telemetry capture."""
        harness = harness_for(repo_root, vim_bin)
        cmd_list = list(commands) if commands else ["qa!"]
        if "qa!" not in cmd_list:
            cmd_list.append("qa!")
        return harness.run(
            InvocationSpec(file=Path(file) if file else None, ex_commands=tuple(cmd_list)),
            telemetry=TelemetrySpec(
                capture_startuptime=startuptime,
                capture_scriptinfo=scriptinfo,
                capture_profile=profile,
                capture_verbose=verbose,
                capture_channel_log=channel_log,
            ),
            emit_bundle=emit_bundle,
        )

    @mcp.tool
    def benchmark_vim(
        repo_root: str | None = None,
        vim_bin: str | None = None,
        label: str = "benchmark",
        emit_bundle: bool = False,
    ) -> BenchmarkReport:
        """Run the default startup benchmark suite and return the typed report."""
        harness = harness_for(repo_root, vim_bin)
        return harness.benchmark(
            harness.default_benchmark_spec(
                label=label,
                emit_bundle=emit_bundle,
                append_history=emit_bundle,
            )
        )

    @mcp.tool
    def compare_refs(
        repo_root: str | None = None,
        vim_bin: str | None = None,
        base_ref: str | None = None,
        target_ref: str = "HEAD",
        emit_bundle: bool = False,
        run_correctness: bool = True,
    ) -> CompareReport:
        """Benchmark and compare a target ref against a baseline ref."""
        harness = harness_for(repo_root, vim_bin)
        return harness.compare(
            CompareSpec(
                base_ref=base_ref,
                target_ref=target_ref,
                emit_bundle=emit_bundle,
                run_correctness=run_correctness,
            )
        )

    @mcp.tool
    def compare_multi_refs(
        refs: list[str],
        repo_root: str | None = None,
        vim_bin: str | None = None,
        emit_bundle: bool = False,
    ) -> MultiCompareReport:
        """Benchmark and compare multiple refs pairwise. First ref is the base."""
        harness = harness_for(repo_root, vim_bin)
        return harness.compare_multi(
            tuple(refs),
            CompareSpec(emit_bundle=emit_bundle),
        )

    @mcp.resource("testvim://runs/{run_id}/summary")
    def run_summary(run_id: str) -> ResourceResult:
        harness = resource_harness()
        if harness.spec.artifact_root is None:
            raise ValueError("artifact_root is required for this operation")
        runs_root = harness.spec.artifact_root / "runs"
        path = latest_run_json(runs_root) if run_id == "latest" else runs_root / run_id / "run.json"
        if not path.resolve().is_relative_to(runs_root.resolve()):
            raise ValueError(f"Invalid run_id: {run_id!r}")
        return json_resource(
            load_json(path, description=f"run summary {run_id!r}"),
            mime_type="application/json",
        )

    @mcp.resource("testvim://history/benchmarks")
    def benchmark_history() -> ResourceResult:
        harness = resource_harness()
        if harness.spec.artifact_root is None:
            raise ValueError("artifact_root is required for this operation")
        history = harness.spec.artifact_root / "history.jsonl"
        return json_resource(
            validate_jsonl(history, HistoryEntry, description="benchmark history"),
            mime_type="application/x-ndjson",
        )

    return mcp


def run_mcp_server(harness: VimHarness | None = None, *, transport: str = "stdio", port: int = 8000) -> None:
    server = build_mcp_server(harness)
    if transport == "http":
        server.run(transport="http", port=port)
        return
    server.run()
