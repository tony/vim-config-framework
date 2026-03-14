from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path
from typing import Literal


@dataclass(slots=True, kw_only=True, frozen=True)
class ToolVersion:
    name: str
    path: str | None
    version: str | None


@dataclass(slots=True, kw_only=True, frozen=True)
class GitRepoState:
    root: Path
    branch: str | None
    commit: str | None
    is_dirty: bool
    origin_default_ref: str | None = None


@dataclass(slots=True, kw_only=True, frozen=True)
class PluginInfo:
    name: str
    path: Path
    head: str | None
    is_dirty: bool


@dataclass(slots=True, kw_only=True, frozen=True)
class CapabilityReport:
    vim_bin: str
    version_line: str
    version_output: str
    feature_flags: tuple[str, ...]
    supports_profile: bool
    supports_channel_log: bool
    supports_startuptime: bool
    supports_getscriptinfo: bool


@dataclass(slots=True, kw_only=True, frozen=True)
class EnvironmentReport:
    repo_root: Path
    vimrc_path: Path
    plugin_root: Path | None
    fzf_root: Path | None
    artifact_root: Path
    fixture_root: Path | None
    tools: tuple[ToolVersion, ...]
    git: GitRepoState


@dataclass(slots=True, kw_only=True, frozen=True)
class ArtifactBundle:
    run_id: str
    root: Path
    files: dict[str, Path] = field(default_factory=dict)


@dataclass(slots=True, kw_only=True, frozen=True)
class CommandResult:
    argv: tuple[str, ...]
    shell_command: str
    cwd: Path
    returncode: int
    stdout: str
    stderr: str
    elapsed_seconds: float


@dataclass(slots=True, kw_only=True, frozen=True)
class StartuptimeEvent:
    clock_ms: float
    elapsed_ms: float
    kind: str
    message: str
    self_time_ms: float | None = None


@dataclass(slots=True, kw_only=True, frozen=True)
class StartupProfile:
    raw_path: Path | None
    events: tuple[StartuptimeEvent, ...]
    total_clock_ms: float | None


@dataclass(slots=True, kw_only=True, frozen=True)
class ScriptInfoEntry:
    sid: int | None
    name: str | None
    autoload: bool | None
    sourced: bool | None
    version: int | None


@dataclass(slots=True, kw_only=True, frozen=True)
class ScriptInfoReport:
    raw_path: Path | None
    entries: tuple[ScriptInfoEntry, ...]


@dataclass(slots=True, kw_only=True, frozen=True)
class ProfileEntry:
    kind: str
    name: str
    called_count: int | None
    total_time_seconds: float | None
    self_time_seconds: float | None
    raw_lines: tuple[str, ...]


@dataclass(slots=True, kw_only=True, frozen=True)
class ProfileReport:
    raw_path: Path | None
    entries: tuple[ProfileEntry, ...]


@dataclass(slots=True, kw_only=True, frozen=True)
class SuiteResult:
    suite: Path
    command: CommandResult
    errors: tuple[str, ...]

    @property
    def ok(self) -> bool:
        return self.command.returncode == 0 and not self.errors

    def render_failure(self) -> str:
        parts = [
            f"suite: {self.suite}",
            f"returncode: {self.command.returncode}",
        ]
        if self.errors:
            parts.extend(["errors:", *self.errors])
        if self.command.stdout:
            parts.extend(["stdout:", self.command.stdout])
        if self.command.stderr:
            parts.extend(["stderr:", self.command.stderr])
        return "\n".join(parts)


@dataclass(slots=True, kw_only=True, frozen=True)
class SuiteCollectionResult:
    results: tuple[SuiteResult, ...]

    @property
    def ok(self) -> bool:
        return all(result.ok for result in self.results)


@dataclass(slots=True, kw_only=True, frozen=True)
class RunTelemetry:
    startuptime: StartupProfile | None = None
    scriptinfo: ScriptInfoReport | None = None
    profile: ProfileReport | None = None
    verbose_log: Path | None = None
    channel_log: Path | None = None


@dataclass(slots=True, kw_only=True, frozen=True)
class RunResult:
    command: CommandResult
    capability: CapabilityReport
    environment: EnvironmentReport
    telemetry: RunTelemetry = field(default_factory=RunTelemetry)
    artifact_bundle: ArtifactBundle | None = None

    @property
    def ok(self) -> bool:
        return self.command.returncode == 0


@dataclass(slots=True, kw_only=True, frozen=True)
class TmuxRunResult:
    command: str
    pane_transcript: tuple[str, ...]
    typed_keys: tuple[str, ...]
    ok: bool


@dataclass(slots=True, kw_only=True, frozen=True)
class BenchmarkScenarioResult:
    name: str
    command: str
    mean_seconds: float
    min_seconds: float
    max_seconds: float
    startuptime: StartupProfile | None = None
    scriptinfo: ScriptInfoReport | None = None
    profile: ProfileReport | None = None
    verbose_log: Path | None = None
    channel_log: Path | None = None


@dataclass(slots=True, kw_only=True, frozen=True)
class BenchmarkReport:
    version: int
    run_id: str
    generated_at: str
    label: str
    capability: CapabilityReport
    environment: EnvironmentReport
    plugin_manifest: tuple[PluginInfo, ...]
    scenarios: tuple[BenchmarkScenarioResult, ...]
    artifact_bundle: ArtifactBundle | None = None


@dataclass(slots=True, kw_only=True, frozen=True)
class CompareScenarioDelta:
    name: str
    base_mean_seconds: float
    target_mean_seconds: float
    percent_delta: float
    classification: Literal["noise", "faster", "slower"]


@dataclass(slots=True, kw_only=True, frozen=True)
class CompareReport:
    version: int
    generated_at: str
    base_ref: str
    target_ref: str
    base_commit: str | None
    target_commit: str | None
    base_correctness_ok: bool
    target_correctness_ok: bool
    base_benchmark: BenchmarkReport | None
    target_benchmark: BenchmarkReport | None
    scenarios: tuple[CompareScenarioDelta, ...]
    base_suites: SuiteCollectionResult | None = None
    target_suites: SuiteCollectionResult | None = None
    artifact_bundle: ArtifactBundle | None = None


@dataclass(slots=True, kw_only=True, frozen=True)
class MultiCompareReport:
    version: int
    generated_at: str
    refs: tuple[str, ...]
    commits: tuple[str | None, ...]
    pairwise: tuple[CompareReport, ...]
    artifact_bundle: ArtifactBundle | None = None


@dataclass(slots=True, kw_only=True, frozen=True)
class HistoryEntry:
    run_id: str
    label: str
    scenario: str
    generated_at: str
    branch: str | None
    commit: str | None
    vim_bin: str
    vim_version: str
    mean_seconds: float
    min_seconds: float
    max_seconds: float
