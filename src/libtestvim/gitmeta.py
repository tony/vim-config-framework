from __future__ import annotations

import subprocess
from pathlib import Path

from libtestvim.models import GitRepoState, PluginInfo


def _git(repo_root: Path, *args: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", "-C", str(repo_root), *args],
        capture_output=True,
        text=True,
        check=False,
    )


def git_output(repo_root: Path, *args: str) -> str | None:
    completed = _git(repo_root, *args)
    if completed.returncode != 0:
        return None
    return completed.stdout.strip()


def repo_is_dirty(repo_root: Path) -> bool:
    completed = _git(repo_root, "status", "--short")
    return completed.returncode == 0 and bool(completed.stdout.strip())


def detect_origin_default_ref(repo_root: Path) -> str | None:
    detected = git_output(repo_root, "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD")
    if detected:
        return detected

    for fallback in ("origin/master", "origin/main"):
        if git_output(repo_root, "rev-parse", "--verify", fallback) is not None:
            return fallback

    return None


def collect_repo_state(repo_root: Path) -> GitRepoState:
    branch = git_output(repo_root, "branch", "--show-current")
    commit = git_output(repo_root, "rev-parse", "HEAD")
    origin_default_ref = git_output(repo_root, "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD")
    return GitRepoState(
        root=repo_root,
        branch=branch or None,
        commit=commit or None,
        is_dirty=repo_is_dirty(repo_root),
        origin_default_ref=origin_default_ref or None,
    )


def collect_plugin_manifest(plugin_root: Path | None, fzf_root: Path | None) -> tuple[PluginInfo, ...]:
    manifest: list[PluginInfo] = []
    if plugin_root and plugin_root.is_dir():
        for plugin_path in sorted(path for path in plugin_root.iterdir() if path.is_dir()):
            head = git_output(plugin_path, "rev-parse", "HEAD")
            if head is None:
                continue
            manifest.append(
                PluginInfo(
                    name=plugin_path.name,
                    path=plugin_path,
                    head=head,
                    is_dirty=repo_is_dirty(plugin_path),
                )
            )

    if fzf_root and fzf_root.is_dir():
        head = git_output(fzf_root, "rev-parse", "HEAD")
        if head is not None:
            manifest.append(
                PluginInfo(
                    name="fzf",
                    path=fzf_root,
                    head=head,
                    is_dirty=repo_is_dirty(fzf_root),
                )
            )

    return tuple(manifest)
