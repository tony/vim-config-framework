from __future__ import annotations

from pathlib import Path

import pytest

pytest.importorskip(
    "libtmux",
    reason="Install test dependencies with `uv sync --group test` and run via `uv run --group test pytest` or `just test-tmux`.",
)

from libtestvim.specs import InvocationSpec
from libtestvim.tmux import run_in_tmux


@pytest.mark.tmux
def test_vim_starts_and_handles_basic_input_in_tmux(
    vim_harness,
    tmp_path: Path,
) -> None:
    fixture = tmp_path / "tmux-smoke.py"
    fixture.write_text("TMUX_SMOKE_START\n", encoding="utf-8")

    result = run_in_tmux(
        vim_harness,
        InvocationSpec(
            file=fixture,
            ex_commands=(),
            tty=True,
            headless=False,
        ),
        typed_keys=("G", "oTMUX_TYPED_SENTINEL", "Escape"),
        ready_text="TMUX_SMOKE_START",
        expected_text="TMUX_TYPED_SENTINEL",
    )

    transcript = "\n".join(result.pane_transcript)
    assert result.ok
    assert "TMUX_SMOKE_START" in transcript
    assert "TMUX_TYPED_SENTINEL" in transcript
