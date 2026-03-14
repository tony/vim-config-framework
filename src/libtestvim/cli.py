from __future__ import annotations

import argparse
import sys
from dataclasses import is_dataclass
from pathlib import Path

from libtestvim.harness import VimHarness
from libtestvim.models import (
    BenchmarkReport,
    CapabilityReport,
    CompareReport,
    MultiCompareReport,
    RunResult,
    SuiteCollectionResult,
)
from libtestvim.serde import json_schema, to_json, to_jsonl
from libtestvim.specs import BenchmarkSpec, CompareSpec, InvocationSpec, TelemetrySpec

SCHEMA_TYPES = {
    "benchmark-report": "BenchmarkReport",
    "compare-report": "CompareReport",
    "multi-compare-report": "MultiCompareReport",
    "run-result": "RunResult",
    "history-entry": "HistoryEntry",
}


def _build_harness(args: argparse.Namespace) -> VimHarness:
    return VimHarness.from_repo(
        args.repo_root,
        vim_bin=args.vim_bin,
        artifact_root=args.artifact_root,
        plugin_root=args.plugin_root,
        fzf_root=args.fzf_root,
        fixture_root=args.fixture_root,
    )


def _emit(value, output: str) -> None:
    if output == "pretty":
        sys.stdout.write(_pretty(value) + "\n")
        return
    if output == "jsonl":
        if isinstance(value, (list, tuple)):
            sys.stdout.write(to_jsonl(value))
        else:
            sys.stdout.write(to_jsonl([value]))
        return
    sys.stdout.write(to_json(value, indent=2) + "\n")


def _pretty(value) -> str:
    if isinstance(value, CapabilityReport):
        features = [
            f"profile={'yes' if value.supports_profile else 'no'}",
            f"channel-log={'yes' if value.supports_channel_log else 'no'}",
            f"startuptime={'yes' if value.supports_startuptime else 'no'}",
            f"getscriptinfo={'yes' if value.supports_getscriptinfo else 'no'}",
        ]
        return f"{value.version_line}\n" + "\n".join(features)

    if isinstance(value, RunResult):
        lines = [
            f"returncode: {value.command.returncode}",
            f"elapsed_seconds: {value.command.elapsed_seconds:.3f}",
        ]
        if value.artifact_bundle is not None:
            lines.append(f"artifact_bundle: {value.artifact_bundle.root}")
        return "\n".join(lines)

    if isinstance(value, BenchmarkReport):
        lines = [
            f"run_id: {value.run_id}",
            f"label: {value.label}",
            f"artifact_bundle: {value.artifact_bundle.root if value.artifact_bundle else '<none>'}",
        ]
        for scenario in value.scenarios:
            lines.append(
                f"{scenario.name}: mean={scenario.mean_seconds:.4f}s"
                f" min={scenario.min_seconds:.4f}s max={scenario.max_seconds:.4f}s"
            )
        return "\n".join(lines)

    if isinstance(value, MultiCompareReport):
        lines = [
            f"refs: {' -> '.join(value.refs)}",
            f"artifact_bundle: {value.artifact_bundle.root if value.artifact_bundle else '<none>'}",
        ]
        for pair in value.pairwise:
            lines.append(f"\n--- {pair.base_ref} vs {pair.target_ref} ---")
            lines.append(f"base_correctness: {'ok' if pair.base_correctness_ok else 'failed'}")
            lines.append(f"target_correctness: {'ok' if pair.target_correctness_ok else 'failed'}")
            for scenario in pair.scenarios:
                lines.append(f"{scenario.name}: {scenario.classification} ({scenario.percent_delta:+.2f}%)")
        return "\n".join(lines)

    if isinstance(value, CompareReport):
        lines = [
            f"base_ref: {value.base_ref}",
            f"target_ref: {value.target_ref}",
            f"base_correctness: {'ok' if value.base_correctness_ok else 'failed'}",
            f"target_correctness: {'ok' if value.target_correctness_ok else 'failed'}",
            f"artifact_bundle: {value.artifact_bundle.root if value.artifact_bundle else '<none>'}",
        ]
        lines.extend(_suite_failure_lines("base", value.base_suites))
        lines.extend(_suite_failure_lines("target", value.target_suites))
        for scenario in value.scenarios:
            lines.append(f"{scenario.name}: {scenario.classification} ({scenario.percent_delta:+.2f}%)")
        return "\n".join(lines)

    if is_dataclass(value):
        return to_json(value, indent=2)

    return str(value)


def _suite_failure_lines(prefix: str, suites: SuiteCollectionResult | None) -> list[str]:
    if suites is None or suites.ok:
        return []

    lines = [f"{prefix}_suite_failures:"]
    for result in suites.results:
        if result.ok:
            continue
        lines.append(f"{prefix}: {result.suite.name}")
        lines.append(result.render_failure())
    return lines


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="testvim")
    parser.add_argument("--repo-root", default=".")
    parser.add_argument("--vim-bin", default="vim")
    parser.add_argument("--artifact-root", default=None)
    parser.add_argument("--plugin-root", default=None)
    parser.add_argument("--fzf-root", default=None)
    parser.add_argument("--fixture-root", default=None)

    subparsers = parser.add_subparsers(dest="command", required=True)

    probe = subparsers.add_parser("probe")
    probe.add_argument("--output", choices=("pretty", "json", "jsonl"), default="pretty")

    run = subparsers.add_parser("run")
    run.add_argument("--file", default=None)
    run.add_argument("--cmd", action="append", default=[])
    run.add_argument("--cwd", default=None)
    run.add_argument("--tty", action="store_true")
    run.add_argument("--emit-bundle", action="store_true")
    run.add_argument("--startuptime", action="store_true")
    run.add_argument("--scriptinfo", action="store_true")
    run.add_argument("--profile", action="store_true")
    run.add_argument("--verbose", action="store_true")
    run.add_argument("--channel-log", action="store_true")
    run.add_argument("--label", default="run")
    run.add_argument("--output", choices=("pretty", "json", "jsonl"), default="pretty")

    bench = subparsers.add_parser("bench")
    bench.add_argument("--label", default="benchmark")
    bench.add_argument("--emit-bundle", action="store_true")
    bench.add_argument("--append-history", action="store_true")
    bench.add_argument("--profile", choices=("warm", "fresh"), default="warm")
    bench.add_argument("--output", choices=("pretty", "json", "jsonl"), default="pretty")

    compare = subparsers.add_parser("compare")
    compare.add_argument("--base-ref", default=None)
    compare.add_argument("--target-ref", default="HEAD")
    compare.add_argument("--emit-bundle", action="store_true")
    compare.add_argument("--output", choices=("pretty", "json", "jsonl"), default="pretty")

    compare_multi = subparsers.add_parser("compare-multi")
    compare_multi.add_argument("refs", nargs="+")
    compare_multi.add_argument("--emit-bundle", action="store_true")
    compare_multi.add_argument("--output", choices=("pretty", "json", "jsonl"), default="pretty")

    schema = subparsers.add_parser("schema")
    schema.add_argument("name", choices=tuple(SCHEMA_TYPES))
    schema.add_argument("--output", choices=("json", "jsonl"), default="json")

    serve = subparsers.add_parser("serve-mcp")
    serve.add_argument("--transport", choices=("stdio", "http"), default="stdio")
    serve.add_argument("--port", type=int, default=8000)

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    harness = _build_harness(args)

    if args.command == "probe":
        _emit(harness.probe(), args.output)
        return 0

    if args.command == "run":
        invocation = InvocationSpec(
            file=Path(args.file) if args.file else None,
            ex_commands=tuple(args.cmd) if args.cmd else ("qa!",),
            cwd=Path(args.cwd) if args.cwd else None,
            tty=args.tty,
            headless=not args.tty,
        )
        telemetry = TelemetrySpec(
            capture_startuptime=args.startuptime,
            capture_scriptinfo=args.scriptinfo,
            capture_profile=args.profile,
            capture_verbose=args.verbose,
            capture_channel_log=args.channel_log,
        )
        result = harness.run(invocation, telemetry=telemetry, emit_bundle=args.emit_bundle, label=args.label)
        _emit(result, args.output)
        return 0 if result.ok else 1

    if args.command == "bench":
        spec = harness.default_benchmark_spec(
            label=args.label,
            emit_bundle=args.emit_bundle,
            append_history=args.append_history,
        )
        spec = BenchmarkSpec(
            label=spec.label,
            scenarios=spec.scenarios,
            warmup_runs=spec.warmup_runs,
            timed_runs=spec.timed_runs,
            profile=args.profile,
            timer_backend=spec.timer_backend,
            emit_bundle=spec.emit_bundle,
            append_history=spec.append_history,
            telemetry=spec.telemetry,
        )
        result = harness.benchmark(spec)
        _emit(result, args.output)
        return 0

    if args.command == "compare":
        spec = CompareSpec(base_ref=args.base_ref, target_ref=args.target_ref, emit_bundle=args.emit_bundle)
        result = harness.compare(spec)
        _emit(result, args.output)
        return 0 if result.base_correctness_ok and result.target_correctness_ok else 1

    if args.command == "compare-multi":
        spec = CompareSpec(emit_bundle=args.emit_bundle, run_correctness=True)
        result = harness.compare_multi(tuple(args.refs), spec)
        _emit(result, args.output)
        all_ok = all(p.base_correctness_ok and p.target_correctness_ok for p in result.pairwise)
        return 0 if all_ok else 1

    if args.command == "schema":
        from libtestvim import BenchmarkReport, CompareReport, HistoryEntry, MultiCompareReport, RunResult

        type_map = {
            "benchmark-report": BenchmarkReport,
            "compare-report": CompareReport,
            "multi-compare-report": MultiCompareReport,
            "run-result": RunResult,
            "history-entry": HistoryEntry,
        }
        _emit(json_schema(type_map[args.name]), args.output)
        return 0

    if args.command == "serve-mcp":
        from libtestvim.mcp_server import run_mcp_server

        run_mcp_server(harness, transport=args.transport, port=args.port)
        return 0

    parser.error(f"Unknown command: {args.command}")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
