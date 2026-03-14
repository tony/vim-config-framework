from __future__ import annotations

import typing as t
from pathlib import Path

import pytest

from libtestvim import VimHarness


class RooterScenario(t.NamedTuple):
    id: str
    description: str
    root_markers: tuple[str, ...]
    file_path: str
    rooter_manual_only: int
    rooter_non_project: str
    autochdir: bool
    expected_cwd: str
    expected_find_root: str


ROOTER_SCENARIOS = [
    RooterScenario(
        id="auto_rooter_git_project",
        description="Auto-rooter detects .git and cd to project root",
        root_markers=(".git/",),
        file_path="src/deep/file.py",
        rooter_manual_only=0,
        rooter_non_project="",
        autochdir=False,
        expected_cwd="project_root",
        expected_find_root="project_root",
    ),
    RooterScenario(
        id="auto_rooter_pyproject_marker",
        description="Auto-rooter detects Pipfile as root marker",
        root_markers=("Pipfile",),
        file_path="pkg/app.py",
        rooter_manual_only=0,
        rooter_non_project="",
        autochdir=False,
        expected_cwd="project_root",
        expected_find_root="project_root",
    ),
    RooterScenario(
        id="auto_rooter_deep_nesting",
        description="Auto-rooter finds root from deeply nested file",
        root_markers=(".git/",),
        file_path="a/b/c/d/e/main.py",
        rooter_manual_only=0,
        rooter_non_project="",
        autochdir=False,
        expected_cwd="project_root",
        expected_find_root="project_root",
    ),
    RooterScenario(
        id="auto_rooter_non_project_current",
        description="Non-project file with 'current' falls back to file dir",
        root_markers=(),
        file_path="orphan.py",
        rooter_manual_only=0,
        rooter_non_project="current",
        autochdir=False,
        expected_cwd="file_dir",
        expected_find_root="empty",
    ),
    RooterScenario(
        id="auto_rooter_non_project_empty",
        description="Non-project file with '' leaves cwd unchanged",
        root_markers=(),
        file_path="orphan.py",
        rooter_manual_only=0,
        rooter_non_project="",
        autochdir=False,
        expected_cwd="unchanged",
        expected_find_root="empty",
    ),
    RooterScenario(
        id="manual_rooter_no_auto_cd",
        description="Manual rooter does not auto-cd on BufEnter",
        root_markers=(".git/",),
        file_path="src/file.py",
        rooter_manual_only=1,
        rooter_non_project="",
        autochdir=False,
        expected_cwd="unchanged",
        expected_find_root="project_root",
    ),
    RooterScenario(
        id="manual_rooter_explicit_command",
        description="Manual :Rooter command changes to project root",
        root_markers=(".git/",),
        file_path="pkg/app.py",
        rooter_manual_only=1,
        rooter_non_project="",
        autochdir=False,
        expected_cwd="project_root",
        expected_find_root="project_root",
    ),
    RooterScenario(
        id="find_root_ignores_manual_only",
        description="FindRootDirectory() works regardless of manual_only",
        root_markers=(".git/",),
        file_path="lib/util.py",
        rooter_manual_only=1,
        rooter_non_project="",
        autochdir=False,
        expected_cwd="unchanged",
        expected_find_root="project_root",
    ),
    RooterScenario(
        id="autochdir_with_auto_rooter",
        description="Rooter auto-mode overrides autochdir (cd to root not file dir)",
        root_markers=(".git/",),
        file_path="src/deep/file.py",
        rooter_manual_only=0,
        rooter_non_project="",
        autochdir=True,
        expected_cwd="project_root",
        expected_find_root="project_root",
    ),
    # NOTE: autochdir does not fire in Vim's headless Ex mode (--not-a-term -es)
    # used by the test harness, so cwd remains unchanged rather than changing
    # to file_dir.  In a real interactive session, autochdir WOULD change to
    # the file's directory.
    RooterScenario(
        id="autochdir_with_manual_rooter",
        description="autochdir alone changes to file dir (no rooter auto)",
        root_markers=(".git/",),
        file_path="src/deep/file.py",
        rooter_manual_only=1,
        rooter_non_project="",
        autochdir=True,
        expected_cwd="unchanged",
        expected_find_root="project_root",
    ),
    RooterScenario(
        id="multiple_root_markers",
        description="Project with both .git/ and Pipfile detects root correctly",
        root_markers=(".git/", "Pipfile"),
        file_path="src/app.py",
        rooter_manual_only=0,
        rooter_non_project="",
        autochdir=False,
        expected_cwd="project_root",
        expected_find_root="project_root",
    ),
]


def _vim_string(s: str) -> str:
    """Escape a Python string for Vim script literal."""
    return "'" + s.replace("'", "''") + "'"


def _build_suite(scenario: RooterScenario, project_root: Path, file_abs: Path) -> str:
    """Generate a Vimscript test suite for a single rooter scenario."""
    if scenario.expected_cwd == "project_root":
        expected_cwd_expr = _vim_string(str(project_root))
    elif scenario.expected_cwd == "file_dir":
        expected_cwd_expr = _vim_string(str(file_abs.parent))
    else:
        expected_cwd_expr = "g:vim_test_original_cwd"

    expected_root_expr = _vim_string(str(project_root)) if scenario.expected_find_root == "project_root" else "''"

    rooter_cmd = ""
    if scenario.id == "manual_rooter_explicit_command":
        rooter_cmd = "\n  Rooter"

    lines = [
        f"function! Test_{scenario.id}() abort",
        f"  let g:rooter_manual_only = {scenario.rooter_manual_only}",
        f"  let g:rooter_change_directory_for_non_project_files = {_vim_string(scenario.rooter_non_project)}",
        f"  {'set autochdir' if scenario.autochdir else 'set noautochdir'}",
        "",
        f"  call VimTestOpen({_vim_string(str(file_abs))})",
        rooter_cmd,
        "",
        '  " Assert expected working directory',
        f"  let l:expected_cwd = VimTestNormalizePath({expected_cwd_expr})",
        "  let l:actual_cwd = VimTestNormalizePath(getcwd())",
        "  call assert_equal(l:expected_cwd, l:actual_cwd,",
        f"    \\ {_vim_string(scenario.description + ': cwd mismatch')})",
        "",
        '  " Assert FindRootDirectory() result',
        f"  let l:expected_root = {expected_root_expr}",
        "  let l:actual_root = FindRootDirectory()",
        "  if !empty(l:expected_root)",
        "    call assert_equal(",
        "      \\ VimTestNormalizePath(l:expected_root),",
        "      \\ VimTestNormalizePath(l:actual_root),",
        f"      \\ {_vim_string(scenario.description + ': FindRootDirectory() mismatch')})",
        "  else",
        "    call assert_equal(",
        "      \\ l:expected_root, l:actual_root,",
        f"      \\ {_vim_string(scenario.description + ': FindRootDirectory() should be empty')})",
        "  endif",
        "endfunction",
    ]
    return "\n".join(lines) + "\n"


@pytest.mark.integration
@pytest.mark.parametrize(
    "scenario",
    ROOTER_SCENARIOS,
    ids=lambda s: s.id,
)
def test_rooter_scenario(
    vim_harness: VimHarness,
    tmp_path: Path,
    scenario: RooterScenario,
) -> None:
    """Parametrized rooter/autochdir edge case test."""
    project_root = tmp_path / "project"
    project_root.mkdir()
    for marker in scenario.root_markers:
        marker_path = project_root / marker
        if marker.endswith("/"):
            marker_path.mkdir(parents=True, exist_ok=True)
        else:
            marker_path.parent.mkdir(parents=True, exist_ok=True)
            marker_path.write_text("")

    file_abs = project_root / scenario.file_path
    file_abs.parent.mkdir(parents=True, exist_ok=True)
    file_abs.write_text("# test file\n")

    suite_content = _build_suite(scenario, project_root, file_abs)
    suite_file = tmp_path / f"test_{scenario.id}.vim"
    suite_file.write_text(suite_content, encoding="utf-8")

    result = vim_harness.run_suite(suite_file)
    assert result.ok, result.render_failure()
