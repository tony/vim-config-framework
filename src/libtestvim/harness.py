from __future__ import annotations

import json
import os
import shlex
import shutil
import subprocess
import sys
import tempfile
import time
from collections.abc import Iterable, Iterator
from contextlib import ExitStack, contextmanager
from dataclasses import dataclass, replace
from pathlib import Path
from typing import Literal

from libtestvim.artifacts import append_jsonl, bundle_path, create_bundle, write_bundle_json
from libtestvim.capabilities import collect_tool_versions, probe_capabilities
from libtestvim.gitmeta import collect_plugin_manifest, collect_repo_state, detect_origin_default_ref
from libtestvim.models import (
    BenchmarkReport,
    BenchmarkScenarioResult,
    CommandResult,
    CompareReport,
    CompareScenarioDelta,
    EnvironmentReport,
    HistoryEntry,
    MultiCompareReport,
    RunResult,
    RunTelemetry,
    SuiteCollectionResult,
    SuiteResult,
)
from libtestvim.parsers import parse_profile, parse_scriptinfo, parse_startuptime
from libtestvim.specs import BenchmarkScenarioSpec, BenchmarkSpec, CompareSpec, HarnessSpec, InvocationSpec, TelemetrySpec
from libtestvim.util import shell_join, slugify_label, utc_now_iso, vim_string


@dataclass(slots=True)
class _RuntimeContext:
    temp_root: Path
    home: Path
    state_root: Path
    tmpdir: Path
    wrapper: Path
    env: dict[str, str]
    log_root: Path


class VimHarness:
    _COMPARE_OVERLAY_PATHS = (
        Path("autoload/lib.vim"),
        Path("autoload/plug.vim"),
        Path("settings/autocmd.vim"),
        Path("settings/compat"),
        Path("settings/quirks"),
        Path("plugins.d"),
        Path("plugins.settings"),
    )

    def __init__(self, spec: HarnessSpec):
        repo_root = spec.repo_root.resolve()
        vimrc_path = (spec.vimrc_path or (repo_root / "vimrc")).resolve()
        plugin_root = spec.plugin_root.resolve() if spec.plugin_root else (repo_root / "plugged").resolve()

        fzf_root = spec.fzf_root
        if fzf_root is None:
            default_fzf = Path.home() / ".fzf"
            fzf_root = default_fzf if default_fzf.exists() else plugin_root / "fzf"
        elif fzf_root.exists():
            fzf_root = fzf_root.resolve()
        else:
            fzf_root = None

        artifact_root = (spec.artifact_root or (repo_root / "artifacts" / "vim")).resolve()
        fixture_root = (spec.fixture_root or (repo_root / "tests" / "fixtures")).resolve()

        self.spec = replace(
            spec,
            repo_root=repo_root,
            vimrc_path=vimrc_path,
            plugin_root=plugin_root,
            fzf_root=fzf_root,
            artifact_root=artifact_root,
            fixture_root=fixture_root,
        )
        self._capability_cache = None

    @classmethod
    def from_repo(
        cls,
        repo_root: str | Path,
        *,
        vim_bin: str = "vim",
        plugin_root: str | Path | None = None,
        fzf_root: str | Path | None = None,
        artifact_root: str | Path | None = None,
        fixture_root: str | Path | None = None,
        vimrc_path: str | Path | None = None,
        env: dict[str, str] | None = None,
    ) -> VimHarness:
        def _coerce(path: str | Path | None) -> Path | None:
            return None if path is None else Path(path)

        return cls(
            HarnessSpec(
                repo_root=Path(repo_root),
                vim_bin=vim_bin,
                plugin_root=_coerce(plugin_root),
                fzf_root=_coerce(fzf_root),
                artifact_root=_coerce(artifact_root),
                fixture_root=_coerce(fixture_root),
                vimrc_path=_coerce(vimrc_path),
                env=env or {},
            )
        )

    def probe(self):
        if self._capability_cache is None:
            self._capability_cache = probe_capabilities(self.spec.vim_bin)
        return self._capability_cache

    def environment_report(self) -> EnvironmentReport:
        return EnvironmentReport(
            repo_root=self.spec.repo_root,
            vimrc_path=self.spec.vimrc_path or (self.spec.repo_root / "vimrc"),
            plugin_root=self.spec.plugin_root,
            fzf_root=self.spec.fzf_root,
            artifact_root=self.spec.artifact_root or (self.spec.repo_root / "artifacts" / "vim"),
            fixture_root=self.spec.fixture_root,
            tools=collect_tool_versions(),
            git=collect_repo_state(self.spec.repo_root),
        )

    def default_benchmark_spec(
        self,
        *,
        label: str = "benchmark",
        emit_bundle: bool = False,
        append_history: bool = False,
    ) -> BenchmarkSpec:
        fixtures = self.spec.fixture_root or (self.spec.repo_root / "tests" / "fixtures")
        scenarios = (
            BenchmarkScenarioSpec(name="empty_startup"),
            BenchmarkScenarioSpec(name="open_python_fixture", file=fixtures / "python" / "example.py"),
            BenchmarkScenarioSpec(name="open_typescript_fixture", file=fixtures / "typescript" / "example.ts"),
            BenchmarkScenarioSpec(name="open_markdown_fixture", file=fixtures / "markdown" / "notes.md"),
            BenchmarkScenarioSpec(name="open_vim_fixture", file=fixtures / "vim" / "sample.vim"),
        )
        return BenchmarkSpec(
            label=label,
            scenarios=scenarios,
            emit_bundle=emit_bundle,
            append_history=append_history,
            telemetry=TelemetrySpec(
                capture_startuptime=True,
                capture_scriptinfo=True,
                capture_profile=True,
                capture_verbose=False,
                capture_channel_log=False,
            ),
        )

    def discover_suites(self, kind: str = "all") -> tuple[Path, ...]:
        suite_root = self.spec.repo_root / "tests" / "vim"
        kinds = ("core", "integration") if kind == "all" else (kind,)
        suites: list[Path] = []
        for suite_kind in kinds:
            suites.extend(sorted((suite_root / suite_kind).glob("*.vim")))
        return tuple(suites)

    @contextmanager
    def _runtime(self, *, log_root: Path | None = None) -> Iterator[_RuntimeContext]:
        with tempfile.TemporaryDirectory(prefix="libtestvim-") as tmp:
            temp_root = Path(tmp)
            home = temp_root / "home"
            for relative in [
                ".cache",
                ".config",
                ".local/share",
                ".local/state",
                "tmp",
            ]:
                (home / relative).mkdir(parents=True, exist_ok=True)
            (home / ".vim").symlink_to(self.spec.repo_root, target_is_directory=True)
            (home / ".zshrc").write_text("", encoding="utf-8")

            state_root = temp_root / "state"
            state_root.mkdir(parents=True, exist_ok=True)
            tmpdir = temp_root / "tmp"
            tmpdir.mkdir(parents=True, exist_ok=True)

            env = {
                "HOME": str(home),
                "PATH": self.spec.env.get("PATH", os.environ.get("PATH", "")),
                "LANG": self.spec.env.get("LANG", os.environ.get("LANG", "C.UTF-8")),
                "SHELL": self.spec.env.get("SHELL", os.environ.get("SHELL", "/bin/zsh")),
                "TERM": self.spec.env.get("TERM", os.environ.get("TERM", "screen-256color")),
                "TMPDIR": str(tmpdir),
                "XDG_CACHE_HOME": str(home / ".cache"),
                "XDG_CONFIG_HOME": str(home / ".config"),
                "XDG_DATA_HOME": str(home / ".local" / "share"),
                "XDG_STATE_HOME": str(home / ".local" / "state"),
            }

            for key, value in self.spec.env.items():
                env[key] = value

            actual_log_root = log_root or (temp_root / "logs")
            actual_log_root.mkdir(parents=True, exist_ok=True)

            yield _RuntimeContext(
                temp_root=temp_root,
                home=home,
                state_root=state_root,
                tmpdir=tmpdir,
                wrapper=temp_root / "vimrc.wrapper.vim",
                env=env,
                log_root=actual_log_root,
            )

    def _telemetry_paths(self, runtime: _RuntimeContext, tag: str) -> dict[str, Path]:
        slug = slugify_label(tag)
        paths = {
            "startuptime": runtime.log_root / "startuptime" / f"{slug}.log",
            "scriptinfo": runtime.log_root / "scriptinfo" / f"{slug}.json",
            "profile": runtime.log_root / "profile" / f"{slug}.log",
            "verbose": runtime.log_root / "verbose" / f"{slug}.log",
            "channel": runtime.log_root / "channel" / f"{slug}.log",
        }
        for path in paths.values():
            path.parent.mkdir(parents=True, exist_ok=True)
        return paths

    def _write_wrapper(
        self,
        runtime: _RuntimeContext,
        telemetry: TelemetrySpec,
        telemetry_paths: dict[str, Path],
    ) -> None:
        capability = self.probe()

        lines = [
            "let g:vim_test_mode = 1",
            f"let g:vim_config_root = {vim_string(str(self.spec.repo_root))}",
        ]
        if self.spec.plugin_root is not None:
            lines.append(f"let g:vim_plugin_root = {vim_string(str(self.spec.plugin_root))}")
        if self.spec.fzf_root is not None:
            lines.append(f"let g:vim_fzf_root = {vim_string(str(self.spec.fzf_root))}")
        lines.append(f"let g:vim_state_root = {vim_string(str(runtime.state_root))}")

        if telemetry.capture_scriptinfo and capability.supports_getscriptinfo:
            lines.extend(
                [
                    "function! LibtestvimWriteScriptInfo() abort",
                    "  try",
                    f"    call writefile([json_encode(getscriptinfo())], [{vim_string(str(telemetry_paths['scriptinfo']))}][0])",
                    "  catch",
                    "  endtry",
                    "endfunction",
                    "augroup LibtestvimScriptInfo",
                    "  autocmd!",
                    "  autocmd VimLeavePre * call LibtestvimWriteScriptInfo()",
                    "augroup END",
                ]
            )

        if telemetry.capture_profile and capability.supports_profile:
            lines.extend(
                [
                    "function! LibtestvimStopProfile() abort",
                    "  try",
                    "    profile pause",
                    "    noautocmd profile dump",
                    "    profile stop",
                    "  catch",
                    "  endtry",
                    "endfunction",
                    "augroup LibtestvimProfile",
                    "  autocmd!",
                    "  autocmd VimLeavePre * call LibtestvimStopProfile()",
                    "augroup END",
                    f"execute 'profile start' fnameescape({vim_string(str(telemetry_paths['profile']))})",
                    "profile func *",
                    "profile file *",
                ]
            )

        lines.append(f"execute 'source' fnameescape({vim_string(str(self.spec.vimrc_path))})")
        runtime.wrapper.write_text("\n".join(lines) + "\n", encoding="utf-8")

    def _build_argv(
        self,
        runtime: _RuntimeContext,
        invocation: InvocationSpec,
        telemetry: TelemetrySpec,
        tag: str,
    ) -> tuple[list[str], dict[str, Path]]:
        telemetry_paths = self._telemetry_paths(runtime, tag)
        self._write_wrapper(runtime, telemetry, telemetry_paths)
        capability = self.probe()

        argv = [
            self.spec.vim_bin,
            "-Nu",
            str(runtime.wrapper),
            "-i",
            "NONE",
            "-n",
            "-X",
        ]

        if invocation.headless:
            argv.extend(["--not-a-term", "-es"])

        if telemetry.capture_startuptime and capability.supports_startuptime:
            argv.extend(["--startuptime", str(telemetry_paths["startuptime"])])

        if telemetry.capture_channel_log and capability.supports_channel_log:
            argv.extend(["--log", str(telemetry_paths["channel"])])

        if telemetry.capture_verbose:
            argv.append(f"-V{telemetry.verbose_level}{telemetry_paths['verbose']}")

        argv.extend(invocation.args)
        if invocation.file is not None:
            argv.append(str(invocation.file))
        for command in invocation.ex_commands:
            argv.extend(["-c", command])

        return argv, telemetry_paths

    def _shell_command(self, runtime: _RuntimeContext, argv: list[str], env: dict[str, str]) -> str:
        env_prefix = [
            "env",
            "-u",
            "VIMINIT",
            "-u",
            "EXINIT",
            "-u",
            "GVIMINIT",
            "-u",
            "MYVIMRC",
        ]
        known_keys = {
            "HOME",
            "PATH",
            "LANG",
            "SHELL",
            "TERM",
            "TMPDIR",
            "XDG_CACHE_HOME",
            "XDG_CONFIG_HOME",
            "XDG_DATA_HOME",
            "XDG_STATE_HOME",
        }
        for key in known_keys:
            if key in env:
                env_prefix.append(f"{key}={env[key]}")
        for key in sorted(env):
            if key not in known_keys:
                env_prefix.append(f"{key}={env[key]}")
        return shell_join([*env_prefix, *argv])

    def _execute(
        self,
        runtime: _RuntimeContext,
        invocation: InvocationSpec,
        telemetry: TelemetrySpec,
        *,
        tag: str,
    ) -> tuple[CommandResult, RunTelemetry, dict[str, Path]]:
        argv, telemetry_paths = self._build_argv(runtime, invocation, telemetry, tag)
        env = {**runtime.env, **invocation.env_overrides}
        cwd = (invocation.cwd or self.spec.repo_root).resolve()
        started = time.perf_counter()
        try:
            completed = subprocess.run(
                argv,
                cwd=cwd,
                env=env,
                capture_output=not invocation.tty,
                text=True,
                check=False,
                timeout=30,
            )
        except subprocess.TimeoutExpired as exc:
            raise RuntimeError(f"Vim process timed out after 30s: {shell_join(argv)}") from exc
        elapsed = time.perf_counter() - started
        shell_command = self._shell_command(runtime, argv, env)
        command = CommandResult(
            argv=tuple(argv),
            shell_command=shell_command,
            cwd=cwd,
            returncode=completed.returncode,
            stdout=completed.stdout or "",
            stderr=completed.stderr or "",
            elapsed_seconds=elapsed,
        )
        telemetry_payload = RunTelemetry(
            startuptime=parse_startuptime(telemetry_paths["startuptime"]) if telemetry.capture_startuptime else None,
            scriptinfo=parse_scriptinfo(telemetry_paths["scriptinfo"]) if telemetry.capture_scriptinfo else None,
            profile=parse_profile(telemetry_paths["profile"]) if telemetry.capture_profile else None,
            verbose_log=telemetry_paths["verbose"] if telemetry.capture_verbose and telemetry_paths["verbose"].exists() else None,
            channel_log=telemetry_paths["channel"]
            if telemetry.capture_channel_log and telemetry_paths["channel"].exists()
            else None,
        )
        return command, telemetry_payload, telemetry_paths

    def run(
        self,
        invocation: InvocationSpec | None = None,
        *,
        telemetry: TelemetrySpec | None = None,
        emit_bundle: bool = False,
        label: str = "run",
    ) -> RunResult:
        invocation = invocation or InvocationSpec()
        telemetry = telemetry or TelemetrySpec()
        artifact_root = self.spec.artifact_root
        if artifact_root is None:
            raise ValueError("artifact_root is required for this operation")
        bundle = create_bundle(artifact_root, "runs", label) if emit_bundle else None

        with self._runtime(log_root=bundle.root if bundle else None) as runtime:
            command, telemetry_payload, telemetry_paths = self._execute(runtime, invocation, telemetry, tag=label)
            result = RunResult(
                command=command,
                capability=self.probe(),
                environment=self.environment_report(),
                telemetry=telemetry_payload,
                artifact_bundle=bundle,
            )
            if bundle is not None:
                write_bundle_json(bundle, "run.json", result)
                for _key, path in telemetry_paths.items():
                    if path.exists():
                        bundle_path(bundle, f"raw/{path.name}").write_text(path.read_text(encoding="utf-8"), encoding="utf-8")
            return result

    def run_suite(self, suite: Path) -> SuiteResult:
        suite = suite.resolve()
        runner = (self.spec.repo_root / "tests" / "vim" / "runner.vim").resolve()
        with self._runtime() as runtime:
            result_file = runtime.temp_root / "suite-errors.txt"
            invocation = InvocationSpec(
                args=(
                    "-c",
                    f"let g:vim_suite={vim_string(str(suite))}",
                    "-c",
                    f"let g:vim_test_result_file={vim_string(str(result_file))}",
                    "-S",
                    str(runner),
                ),
                ex_commands=(),
            )
            command, _, _ = self._execute(runtime, invocation, TelemetrySpec(), tag=suite.stem)
            errors = ()
            if result_file.exists():
                errors = tuple(line for line in result_file.read_text(encoding="utf-8").splitlines() if line)
            return SuiteResult(suite=suite, command=command, errors=errors)

    def run_suites(self, suites: Iterable[Path]) -> SuiteCollectionResult:
        return SuiteCollectionResult(results=tuple(self.run_suite(path) for path in suites))

    def _history_entries(self, report: BenchmarkReport) -> list[HistoryEntry]:
        git = report.environment.git
        return [
            HistoryEntry(
                run_id=report.run_id,
                label=report.label,
                scenario=scenario.name,
                generated_at=report.generated_at,
                branch=git.branch,
                commit=git.commit,
                vim_bin=report.capability.vim_bin,
                vim_version=report.capability.version_line,
                mean_seconds=scenario.mean_seconds,
                min_seconds=scenario.min_seconds,
                max_seconds=scenario.max_seconds,
            )
            for scenario in report.scenarios
        ]

    def benchmark(self, spec: BenchmarkSpec | None = None) -> BenchmarkReport:
        spec = spec or self.default_benchmark_spec()
        if spec.timer_backend != "hyperfine":
            raise ValueError(f"Unsupported timer backend: {spec.timer_backend}")
        if shutil.which(self.spec.hyperfine_bin) is None:
            raise RuntimeError(f"{self.spec.hyperfine_bin} is not installed")

        artifact_root = self.spec.artifact_root
        if artifact_root is None:
            raise ValueError("artifact_root is required for this operation")
        scenarios = spec.scenarios or self.default_benchmark_spec().scenarios
        bundle = create_bundle(artifact_root, "runs", spec.label) if spec.emit_bundle else None
        capability = self.probe()
        environment = self.environment_report()
        plugin_manifest = collect_plugin_manifest(self.spec.plugin_root, self.spec.fzf_root)

        instrumented: dict[str, BenchmarkScenarioResult] = {}
        hyperfine_commands: list[str] = []

        with ExitStack() as stack:
            scenario_runtimes: list[tuple[BenchmarkScenarioSpec, _RuntimeContext]] = []
            for scenario in scenarios:
                if scenario.file is not None and not scenario.file.exists():
                    raise FileNotFoundError(scenario.file)

                scenario_bundle_root = None
                if bundle is not None:
                    scenario_bundle_root = bundle.root / "scenarios" / slugify_label(scenario.name)
                    scenario_bundle_root.mkdir(parents=True, exist_ok=True)

                instrumented_invocation = InvocationSpec(
                    file=scenario.file,
                    args=scenario.args,
                    ex_commands=scenario.ex_commands,
                    cwd=scenario.cwd,
                )
                with self._runtime(log_root=scenario_bundle_root) as runtime:
                    command, telemetry_payload, telemetry_paths = self._execute(
                        runtime,
                        instrumented_invocation,
                        spec.telemetry,
                        tag=scenario.name,
                    )
                    if command.returncode != 0:
                        raise RuntimeError(command.stderr or command.stdout or f"Benchmark scenario failed: {scenario.name}")

                    instrumented[scenario.name] = BenchmarkScenarioResult(
                        name=scenario.name,
                        command=command.shell_command,
                        mean_seconds=0.0,
                        min_seconds=0.0,
                        max_seconds=0.0,
                        startuptime=telemetry_payload.startuptime,
                        scriptinfo=telemetry_payload.scriptinfo,
                        profile=telemetry_payload.profile,
                        verbose_log=telemetry_payload.verbose_log,
                        channel_log=telemetry_payload.channel_log,
                    )
                    if bundle is not None:
                        for _key, path in telemetry_paths.items():
                            if path.exists():
                                relative = Path("raw") / slugify_label(scenario.name) / path.name
                                bundle_path(bundle, str(relative)).write_text(path.read_text(encoding="utf-8"), encoding="utf-8")

                runtime = stack.enter_context(self._runtime())
                scenario_runtimes.append((scenario, runtime))
                timing_invocation = InvocationSpec(
                    file=scenario.file,
                    args=scenario.args,
                    ex_commands=scenario.ex_commands,
                    cwd=scenario.cwd,
                )
                argv, _ = self._build_argv(runtime, timing_invocation, TelemetrySpec(), scenario.name)
                hyperfine_commands.append(self._shell_command(runtime, argv, runtime.env))

            hyperfine_json = None
            if bundle is not None:
                hyperfine_json = bundle.root / "hyperfine.json"
            else:
                temp_dir = stack.enter_context(tempfile.TemporaryDirectory(prefix="libtestvim-bench-"))
                hyperfine_json = Path(temp_dir) / "hyperfine.json"

            command = [
                self.spec.hyperfine_bin,
                "--warmup",
                str(spec.warmup_runs),
                "--runs",
                str(spec.timed_runs),
                "--export-json",
                str(hyperfine_json),
            ]
            if spec.profile == "fresh":
                # Clear only mutable harness state before each timing run.
                prepare_parts = []
                for _, runtime in scenario_runtimes:
                    prepare_parts.extend(
                        [
                            f"rm -rf {shlex.quote(str(runtime.state_root))}",
                            f"mkdir -p {shlex.quote(str(runtime.state_root))}",
                        ]
                    )
                if prepare_parts:
                    command.extend(["--prepare", " && ".join(prepare_parts)])

            command.extend(hyperfine_commands)
            try:
                completed = subprocess.run(
                    command,
                    cwd=self.spec.repo_root,
                    capture_output=True,
                    text=True,
                    check=False,
                    timeout=300,
                )
            except subprocess.TimeoutExpired as exc:
                raise RuntimeError("hyperfine timed out after 300s") from exc
            if completed.returncode != 0:
                raise RuntimeError(completed.stderr or completed.stdout or "hyperfine failed")

            hyperfine_results = json.loads(hyperfine_json.read_text(encoding="utf-8"))

        scenario_results: list[BenchmarkScenarioResult] = []
        for scenario, result in zip(scenarios, hyperfine_results["results"], strict=True):
            instrumented_result = instrumented[scenario.name]
            scenario_results.append(
                BenchmarkScenarioResult(
                    name=scenario.name,
                    command=instrumented_result.command,
                    mean_seconds=result["mean"],
                    min_seconds=result["min"],
                    max_seconds=result["max"],
                    startuptime=instrumented_result.startuptime,
                    scriptinfo=instrumented_result.scriptinfo,
                    profile=instrumented_result.profile,
                    verbose_log=instrumented_result.verbose_log,
                    channel_log=instrumented_result.channel_log,
                )
            )

        report = BenchmarkReport(
            version=1,
            run_id=bundle.run_id if bundle else slugify_label(spec.label),
            generated_at=utc_now_iso(),
            label=spec.label,
            capability=capability,
            environment=environment,
            plugin_manifest=plugin_manifest,
            scenarios=tuple(scenario_results),
            artifact_bundle=bundle,
        )

        if bundle is not None:
            write_bundle_json(bundle, "summary.json", report)
            write_bundle_json(bundle, "environment.json", environment)
            write_bundle_json(bundle, "plugin-manifest.json", plugin_manifest)
            write_bundle_json(bundle, "hyperfine.json", hyperfine_results)

            if spec.append_history:
                append_jsonl(artifact_root / "history.jsonl", self._history_entries(report))

        return report

    @contextmanager
    def _temporary_worktree(self, ref: str) -> Iterator[Path]:
        with tempfile.TemporaryDirectory(prefix="libtestvim-worktree-") as tmp:
            path = Path(tmp) / slugify_label(ref)
            completed = subprocess.run(
                ["git", "-C", str(self.spec.repo_root), "worktree", "add", "--detach", str(path), ref],
                capture_output=True,
                text=True,
                check=False,
            )
            if completed.returncode != 0:
                raise RuntimeError(completed.stderr or completed.stdout or f"Failed to add worktree for {ref}")
            try:
                self._overlay_local_runtime(path)
                yield path
            finally:
                remove_completed = subprocess.run(
                    ["git", "-C", str(self.spec.repo_root), "worktree", "remove", "--force", str(path)],
                    capture_output=True,
                    text=True,
                    check=False,
                )
                subprocess.run(
                    ["git", "-C", str(self.spec.repo_root), "worktree", "prune"],
                    capture_output=True,
                    text=True,
                    check=False,
                )
                if remove_completed.returncode != 0:
                    message = remove_completed.stderr or remove_completed.stdout or f"Failed to remove worktree {path}"
                    active_exception = sys.exc_info()[1]
                    if active_exception is not None:
                        active_exception.add_note(message.strip())
                    else:
                        raise RuntimeError(message)

    def _overlay_local_runtime(self, target_root: Path) -> None:
        for relative in self._COMPARE_OVERLAY_PATHS:
            source = self.spec.repo_root / relative
            if not source.exists():
                continue

            destination = target_root / relative
            destination.parent.mkdir(parents=True, exist_ok=True)
            if source.is_dir():
                shutil.copytree(source, destination, dirs_exist_ok=True)
            else:
                shutil.copy2(source, destination)

    def _resolve_benchmark_spec(self, spec: CompareSpec) -> BenchmarkSpec:
        benchmark_spec = replace(spec.benchmark, emit_bundle=spec.emit_bundle)
        if not benchmark_spec.scenarios:
            caller_default = self.default_benchmark_spec(
                label=benchmark_spec.label,
                emit_bundle=spec.emit_bundle,
                append_history=False,
            )
            benchmark_spec = BenchmarkSpec(
                label=benchmark_spec.label,
                scenarios=caller_default.scenarios,
                warmup_runs=benchmark_spec.warmup_runs,
                timed_runs=benchmark_spec.timed_runs,
                profile=benchmark_spec.profile,
                timer_backend=benchmark_spec.timer_backend,
                emit_bundle=benchmark_spec.emit_bundle,
                append_history=False,
                telemetry=benchmark_spec.telemetry,
            )
        return benchmark_spec

    def compare(self, spec: CompareSpec | None = None) -> CompareReport:
        spec = spec or CompareSpec()
        artifact_root = self.spec.artifact_root
        if artifact_root is None:
            raise ValueError("artifact_root is required for this operation")
        repo_state = collect_repo_state(self.spec.repo_root)
        base_ref = spec.base_ref or repo_state.origin_default_ref or detect_origin_default_ref(self.spec.repo_root)
        if base_ref is None:
            base_ref = "origin/master"

        bundle = create_bundle(artifact_root, "compare", f"{base_ref}-vs-{spec.target_ref}") if spec.emit_bundle else None

        with self._temporary_worktree(base_ref) as base_root, self._temporary_worktree(spec.target_ref) as target_root:
            base_harness = VimHarness.from_repo(
                base_root,
                vim_bin=self.spec.vim_bin,
                artifact_root=(bundle.root / "base") if bundle else None,
                plugin_root=self.spec.plugin_root,
                fzf_root=self.spec.fzf_root,
            )
            target_harness = VimHarness.from_repo(
                target_root,
                vim_bin=self.spec.vim_bin,
                artifact_root=(bundle.root / "target") if bundle else None,
                plugin_root=self.spec.plugin_root,
                fzf_root=self.spec.fzf_root,
            )

            base_correctness = True
            target_correctness = True
            base_suite_results = None
            target_suite_results = None
            if spec.run_correctness:
                base_suites = tuple(path for kind in spec.suite_kinds for path in base_harness.discover_suites(kind))
                target_suites = tuple(path for kind in spec.suite_kinds for path in target_harness.discover_suites(kind))
                if base_suites:
                    base_suite_results = base_harness.run_suites(base_suites)
                    base_correctness = base_suite_results.ok
                if target_suites:
                    target_suite_results = target_harness.run_suites(target_suites)
                    target_correctness = target_suite_results.ok

            base_benchmark = None
            target_benchmark = None
            scenario_deltas: list[CompareScenarioDelta] = []
            if base_correctness and target_correctness:
                benchmark_spec = self._resolve_benchmark_spec(spec)
                base_benchmark = base_harness.benchmark(benchmark_spec)
                target_benchmark = target_harness.benchmark(benchmark_spec)

                scenario_deltas = list(self._compute_deltas(base_benchmark, target_benchmark))

            report = CompareReport(
                version=1,
                generated_at=utc_now_iso(),
                base_ref=base_ref,
                target_ref=spec.target_ref,
                base_commit=collect_repo_state(base_root).commit,
                target_commit=collect_repo_state(target_root).commit,
                base_correctness_ok=base_correctness,
                target_correctness_ok=target_correctness,
                base_suites=base_suite_results,
                target_suites=target_suite_results,
                base_benchmark=base_benchmark,
                target_benchmark=target_benchmark,
                scenarios=tuple(scenario_deltas),
                artifact_bundle=bundle,
            )
            if bundle is not None:
                if base_suite_results is not None:
                    write_bundle_json(bundle, "base-suites.json", base_suite_results)
                if target_suite_results is not None:
                    write_bundle_json(bundle, "target-suites.json", target_suite_results)
                write_bundle_json(bundle, "compare.json", report)
            return report

    def _compute_deltas(
        self,
        base_benchmark: BenchmarkReport,
        target_benchmark: BenchmarkReport,
    ) -> tuple[CompareScenarioDelta, ...]:
        base_by_name = {s.name: s for s in base_benchmark.scenarios}
        deltas: list[CompareScenarioDelta] = []
        for target_scenario in target_benchmark.scenarios:
            base_scenario = base_by_name.get(target_scenario.name)
            if base_scenario is None:
                continue
            if base_scenario.mean_seconds == 0.0:
                delta = 0.0 if target_scenario.mean_seconds == 0.0 else float("inf")
            else:
                delta = ((target_scenario.mean_seconds - base_scenario.mean_seconds) / base_scenario.mean_seconds) * 100
            classification: Literal["noise", "faster", "slower"]
            if abs(delta) < 5:
                classification = "noise"
            elif delta < 0:
                classification = "faster"
            else:
                classification = "slower"
            deltas.append(
                CompareScenarioDelta(
                    name=target_scenario.name,
                    base_mean_seconds=base_scenario.mean_seconds,
                    target_mean_seconds=target_scenario.mean_seconds,
                    percent_delta=delta,
                    classification=classification,
                )
            )
        return tuple(deltas)

    def compare_multi(self, refs: tuple[str, ...], spec: CompareSpec | None = None) -> MultiCompareReport:
        if len(refs) < 2:
            raise ValueError("compare_multi requires at least 2 refs")
        spec = spec or CompareSpec()
        artifact_root = self.spec.artifact_root
        if artifact_root is None:
            raise ValueError("artifact_root is required for this operation")

        bundle = create_bundle(artifact_root, "compare-multi", "-vs-".join(refs)) if spec.emit_bundle else None

        with ExitStack() as stack:
            worktree_roots: list[Path] = []
            for ref in refs:
                root = stack.enter_context(self._temporary_worktree(ref))
                worktree_roots.append(root)

            harnesses: list[VimHarness] = []
            for i, root in enumerate(worktree_roots):
                harnesses.append(
                    VimHarness.from_repo(
                        root,
                        vim_bin=self.spec.vim_bin,
                        artifact_root=(bundle.root / f"ref-{i}") if bundle else None,
                        plugin_root=self.spec.plugin_root,
                        fzf_root=self.spec.fzf_root,
                    )
                )

            correctness: list[bool] = []
            suite_results: list[SuiteCollectionResult | None] = []
            for harness in harnesses:
                if spec.run_correctness:
                    suites = tuple(path for kind in spec.suite_kinds for path in harness.discover_suites(kind))
                    if suites:
                        result = harness.run_suites(suites)
                        suite_results.append(result)
                        correctness.append(result.ok)
                    else:
                        suite_results.append(None)
                        correctness.append(True)
                else:
                    suite_results.append(None)
                    correctness.append(True)

            benchmarks: list[BenchmarkReport | None] = []
            benchmark_spec = self._resolve_benchmark_spec(spec)

            for i, harness in enumerate(harnesses):
                if correctness[i]:
                    benchmarks.append(harness.benchmark(benchmark_spec))
                else:
                    benchmarks.append(None)

            pairwise: list[CompareReport] = []
            for i in range(len(refs) - 1):
                base_bm = benchmarks[i]
                target_bm = benchmarks[i + 1]
                deltas = tuple(self._compute_deltas(base_bm, target_bm)) if base_bm and target_bm else ()
                pairwise.append(
                    CompareReport(
                        version=1,
                        generated_at=utc_now_iso(),
                        base_ref=refs[i],
                        target_ref=refs[i + 1],
                        base_commit=collect_repo_state(worktree_roots[i]).commit,
                        target_commit=collect_repo_state(worktree_roots[i + 1]).commit,
                        base_correctness_ok=correctness[i],
                        target_correctness_ok=correctness[i + 1],
                        base_suites=suite_results[i],
                        target_suites=suite_results[i + 1],
                        base_benchmark=base_bm,
                        target_benchmark=target_bm,
                        scenarios=deltas,
                    )
                )

            if len(refs) > 2:
                first_bm = benchmarks[0]
                last_bm = benchmarks[-1]
                overall_deltas = tuple(self._compute_deltas(first_bm, last_bm)) if first_bm and last_bm else ()
                pairwise.append(
                    CompareReport(
                        version=1,
                        generated_at=utc_now_iso(),
                        base_ref=refs[0],
                        target_ref=refs[-1],
                        base_commit=collect_repo_state(worktree_roots[0]).commit,
                        target_commit=collect_repo_state(worktree_roots[-1]).commit,
                        base_correctness_ok=correctness[0],
                        target_correctness_ok=correctness[-1],
                        base_suites=suite_results[0],
                        target_suites=suite_results[-1],
                        base_benchmark=first_bm,
                        target_benchmark=last_bm,
                        scenarios=overall_deltas,
                    )
                )

            commits = tuple(collect_repo_state(root).commit for root in worktree_roots)
            report = MultiCompareReport(
                version=1,
                generated_at=utc_now_iso(),
                refs=refs,
                commits=commits,
                pairwise=tuple(pairwise),
                artifact_bundle=bundle,
            )
            if bundle is not None:
                write_bundle_json(bundle, "multi-compare.json", report)
            return report
