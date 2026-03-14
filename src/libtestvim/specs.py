from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass, field
from pathlib import Path
from typing import Literal


@dataclass(slots=True, kw_only=True, frozen=True)
class HarnessSpec:
    repo_root: Path
    vimrc_path: Path | None = None
    plugin_root: Path | None = None
    fzf_root: Path | None = None
    artifact_root: Path | None = None
    fixture_root: Path | None = None
    vim_bin: str = "vim"
    hyperfine_bin: str = "hyperfine"
    tmux_bin: str = "tmux"
    env: Mapping[str, str] = field(default_factory=dict)


@dataclass(slots=True, kw_only=True, frozen=True)
class TelemetrySpec:
    capture_startuptime: bool = False
    capture_scriptinfo: bool = False
    capture_profile: bool = False
    capture_verbose: bool = False
    verbose_level: int = 10
    capture_channel_log: bool = False


@dataclass(slots=True, kw_only=True, frozen=True)
class InvocationSpec:
    file: Path | None = None
    args: tuple[str, ...] = ()
    ex_commands: tuple[str, ...] = ("qa!",)
    cwd: Path | None = None
    tty: bool = False
    headless: bool = True
    env_overrides: Mapping[str, str] = field(default_factory=dict)


@dataclass(slots=True, kw_only=True, frozen=True)
class BenchmarkScenarioSpec:
    name: str
    file: Path | None = None
    args: tuple[str, ...] = ()
    ex_commands: tuple[str, ...] = ("qa!",)
    cwd: Path | None = None


@dataclass(slots=True, kw_only=True, frozen=True)
class BenchmarkSpec:
    label: str = "benchmark"
    scenarios: tuple[BenchmarkScenarioSpec, ...] = ()
    warmup_runs: int = 1
    timed_runs: int = 3
    profile: Literal["warm", "fresh"] = "warm"
    timer_backend: Literal["hyperfine"] = "hyperfine"
    emit_bundle: bool = False
    append_history: bool = False
    telemetry: TelemetrySpec = field(
        default_factory=lambda: TelemetrySpec(
            capture_startuptime=True,
            capture_scriptinfo=True,
        )
    )


@dataclass(slots=True, kw_only=True, frozen=True)
class CompareSpec:
    base_ref: str | None = None
    target_ref: str = "HEAD"
    emit_bundle: bool = False
    run_correctness: bool = True
    suite_kinds: tuple[str, ...] = ("core", "integration")
    benchmark: BenchmarkSpec = field(default_factory=BenchmarkSpec)
