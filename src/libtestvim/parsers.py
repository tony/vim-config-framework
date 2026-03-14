from __future__ import annotations

import json
import re
from pathlib import Path

from libtestvim.models import (
    ProfileEntry,
    ProfileReport,
    ScriptInfoEntry,
    ScriptInfoReport,
    StartupProfile,
    StartuptimeEvent,
)

_STARTUPTIME_RE = re.compile(r"^(?P<clock>\d+\.\d+)\s+(?P<elapsed>\d+\.\d+)(?:\s+(?P<self_time>\d+\.\d+))?:\s+(?P<message>.*)$")
_CALLED_RE = re.compile(r"(?:Called|Sourced)\s+(?P<count>\d+)\s+time")
_TOTAL_RE = re.compile(r"Total time:\s+(?P<value>\d+\.\d+)")
_SELF_RE = re.compile(r"Self time:\s+(?P<value>\d+\.\d+)")
_SCRIPT_TIMING_RE = re.compile(r"^\s*(?P<count>\d+)\s+(?P<total>\d+\.\d+)\s+(?P<self>\d+\.\d+)\s*$")


def parse_startuptime(path: Path | None) -> StartupProfile | None:
    if path is None or not path.exists():
        return None

    events: list[StartuptimeEvent] = []
    total_clock: float | None = None
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        match = _STARTUPTIME_RE.match(raw_line.strip())
        if match is None:
            continue
        clock_ms = float(match.group("clock"))
        elapsed_ms = float(match.group("elapsed"))
        raw_self = match.group("self_time")
        self_time_ms = float(raw_self) if raw_self is not None else None
        message = match.group("message")
        total_clock = clock_ms
        kind = "script" if "sourcing " in message.lower() else "event"
        events.append(
            StartuptimeEvent(
                clock_ms=clock_ms,
                elapsed_ms=elapsed_ms,
                self_time_ms=self_time_ms,
                kind=kind,
                message=message,
            )
        )

    return StartupProfile(raw_path=path, events=tuple(events), total_clock_ms=total_clock)


def parse_scriptinfo(path: Path | None) -> ScriptInfoReport | None:
    if path is None or not path.exists():
        return None

    text = path.read_text(encoding="utf-8").strip()
    if not text:
        return ScriptInfoReport(raw_path=path, entries=())

    data = json.loads(text)
    entries = tuple(
        ScriptInfoEntry(
            sid=item.get("sid"),
            name=item.get("name"),
            autoload=None if item.get("autoload") is None else bool(item.get("autoload")),
            sourced=None if item.get("sourced") is None else bool(item.get("sourced")),
            version=item.get("version"),
        )
        for item in data
    )
    return ScriptInfoReport(raw_path=path, entries=entries)


def _parse_profile_block(lines: list[str]) -> ProfileEntry:
    header = lines[0]
    kind = "function" if header.startswith("FUNCTION  ") else "script"
    name = header.split(None, 1)[1].strip() if " " in header else header.strip()

    called_count: int | None = None
    total_time: float | None = None
    self_time: float | None = None

    for line in lines[1:]:
        called_match = _CALLED_RE.search(line)
        if called_match:
            called_count = int(called_match.group("count"))

        total_match = _TOTAL_RE.search(line)
        if total_match:
            total_time = float(total_match.group("value"))

        self_match = _SELF_RE.search(line)
        if self_match:
            self_time = float(self_match.group("value"))

        if kind == "script":
            timing_match = _SCRIPT_TIMING_RE.match(line)
            if timing_match:
                called_count = int(timing_match.group("count"))
                total_time = float(timing_match.group("total"))
                self_time = float(timing_match.group("self"))

    return ProfileEntry(
        kind=kind,
        name=name,
        called_count=called_count,
        total_time_seconds=total_time,
        self_time_seconds=self_time,
        raw_lines=tuple(lines),
    )


def parse_profile(path: Path | None) -> ProfileReport | None:
    if path is None or not path.exists():
        return None

    lines = path.read_text(encoding="utf-8").splitlines()
    blocks: list[list[str]] = []
    current: list[str] = []

    for line in lines:
        if line.startswith(("FUNCTION  ", "SCRIPT  ")):
            if current:
                blocks.append(current)
            current = [line]
            continue

        if current:
            current.append(line)

    if current:
        blocks.append(current)

    return ProfileReport(raw_path=path, entries=tuple(_parse_profile_block(block) for block in blocks))
