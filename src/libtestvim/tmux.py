from __future__ import annotations

import uuid
from pathlib import Path

from libtestvim.models import TmuxRunResult
from libtestvim.specs import InvocationSpec, TelemetrySpec


def run_in_tmux(
    harness,
    invocation: InvocationSpec,
    *,
    typed_keys: tuple[str, ...] = (),
    start_directory: Path | None = None,
    ready_text: str | None = None,
    expected_text: str | None = None,
) -> TmuxRunResult:
    try:
        import libtmux
        from libtmux.test.retry import retry_until
        from libtmux.test.temporary import temp_session, temp_window
    except ImportError as exc:  # pragma: no cover - exercised in integration environments
        raise RuntimeError("Install libtestvim with the tmux extra or run `uv sync --group test` to use tmux support.") from exc

    def pane_text(pane) -> tuple[str, ...]:
        pane.refresh()
        return tuple(pane.capture_pane())

    def pane_current_command(pane) -> str:
        pane.refresh()
        return pane.pane_current_command or ""

    socket_name = f"libtestvim_{uuid.uuid4().hex[:10]}"
    server = libtmux.Server(socket_name=socket_name)
    transcript: tuple[str, ...] = ()
    ok = False
    command = ""
    observed_transcript: tuple[str, ...] = ()

    try:
        with harness._runtime() as runtime:
            argv, _ = harness._build_argv(runtime, invocation, TelemetrySpec(), "tmux")
            command = harness._shell_command(runtime, argv, runtime.env)
            with (
                temp_session(server, start_directory=str(start_directory or harness.spec.repo_root), x=160, y=48) as session,
                temp_window(session, window_name="libtestvim", attach=True) as window,
            ):
                pane = window.active_pane
                assert pane is not None
                pane.send_keys(command, enter=True, suppress_history=True)
                if not retry_until(lambda: "vim" in pane_current_command(pane), raises=False):
                    transcript = pane_text(pane)
                    return TmuxRunResult(command=command, pane_transcript=transcript, typed_keys=typed_keys, ok=False)
                if ready_text is not None and not retry_until(
                    lambda: ready_text in "\n".join(pane_text(pane)),
                    raises=False,
                ):
                    transcript = pane_text(pane)
                    return TmuxRunResult(command=command, pane_transcript=transcript, typed_keys=typed_keys, ok=False)
                observed_transcript = pane_text(pane)
                for key in typed_keys:
                    pane.send_keys(key, enter=False)
                sentinel = expected_text or next(
                    (
                        key
                        for key in reversed(typed_keys)
                        if key not in {"Escape", "Enter", "G"} and any(character.isalnum() for character in key)
                    ),
                    None,
                )
                if sentinel is not None and not retry_until(
                    lambda: sentinel in "\n".join(pane_text(pane)),
                    raises=False,
                ):
                    transcript = pane_text(pane)
                    return TmuxRunResult(command=command, pane_transcript=transcript, typed_keys=typed_keys, ok=False)
                if sentinel is not None:
                    observed_transcript = pane_text(pane)
                pane.send_keys(":qa!", enter=True)
                if not retry_until(lambda: "vim" not in pane_current_command(pane), raises=False):
                    transcript = pane_text(pane)
                    return TmuxRunResult(command=command, pane_transcript=transcript, typed_keys=typed_keys, ok=False)
                transcript = observed_transcript or pane_text(pane)
                ok = True
    finally:
        if server.is_alive():
            server.kill()

    return TmuxRunResult(command=command, pane_transcript=transcript, typed_keys=typed_keys, ok=ok)
