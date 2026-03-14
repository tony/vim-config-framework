from __future__ import annotations

import shutil
import subprocess
import tempfile
from pathlib import Path

from libtestvim.models import CapabilityReport, ToolVersion
from libtestvim.util import vim_string

DEFAULT_TOOL_NAMES = ("rg", "ag", "fd", "tmux", "hyperfine", "git", "node")
VERSION_COMMANDS: dict[str, tuple[str, ...]] = {
    "rg": ("rg", "--version"),
    "ag": ("ag", "--version"),
    "fd": ("fd", "--version"),
    "tmux": ("tmux", "-V"),
    "hyperfine": ("hyperfine", "--version"),
    "git": ("git", "--version"),
    "node": ("node", "--version"),
}


def collect_tool_versions(names: tuple[str, ...] = DEFAULT_TOOL_NAMES) -> tuple[ToolVersion, ...]:
    tools: list[ToolVersion] = []
    for name in names:
        executable = shutil.which(name)
        if executable is None:
            tools.append(ToolVersion(name=name, path=None, version=None))
            continue

        version_command = VERSION_COMMANDS.get(name)
        if version_command is None:
            tools.append(ToolVersion(name=name, path=executable, version=None))
            continue
        completed = subprocess.run(
            list(version_command),
            capture_output=True,
            text=True,
            check=False,
        )
        version_line = ""
        if completed.stdout.strip():
            version_line = completed.stdout.splitlines()[0].strip()
        elif completed.stderr.strip():
            version_line = completed.stderr.splitlines()[0].strip()

        tools.append(ToolVersion(name=name, path=executable, version=version_line or None))

    return tuple(tools)


def probe_capabilities(vim_bin: str) -> CapabilityReport:
    version_completed = subprocess.run(
        [vim_bin, "--version"],
        capture_output=True,
        text=True,
        check=False,
    )
    if version_completed.returncode != 0:
        raise RuntimeError(version_completed.stderr or version_completed.stdout or f"Failed to run {vim_bin} --version")

    help_completed = subprocess.run(
        [vim_bin, "-h"],
        capture_output=True,
        text=True,
        check=False,
    )

    version_output = version_completed.stdout
    version_line = version_output.splitlines()[0].strip()
    feature_flags = tuple(
        sorted(
            {
                token
                for token in version_output.split()
                if len(token) > 2 and token[0] in "+-" and token[1:].replace("_", "").isalnum()
            }
        )
    )
    help_output = help_completed.stdout + help_completed.stderr

    with tempfile.TemporaryDirectory(prefix="libtestvim-capability-") as tmpdir:
        result_path = Path(tmpdir) / "getscriptinfo.txt"
        exists_command = f"call writefile([string(exists('*getscriptinfo'))], [{vim_string(str(result_path))}][0])"
        completed = subprocess.run(
            [
                vim_bin,
                "-Nu",
                "NONE",
                "-i",
                "NONE",
                "-n",
                "-X",
                "--not-a-term",
                "-es",
                "-c",
                exists_command,
                "-c",
                "qa!",
            ],
            capture_output=True,
            text=True,
            check=False,
        )
        supports_getscriptinfo = (
            completed.returncode == 0 and result_path.exists() and result_path.read_text(encoding="utf-8").strip() == "1"
        )

    return CapabilityReport(
        vim_bin=vim_bin,
        version_line=version_line,
        version_output=version_output,
        feature_flags=feature_flags,
        supports_profile="+profile" in feature_flags,
        supports_channel_log="+channel" in feature_flags and "--log" in help_output,
        supports_startuptime="--startuptime" in help_output,
        supports_getscriptinfo=supports_getscriptinfo,
    )
