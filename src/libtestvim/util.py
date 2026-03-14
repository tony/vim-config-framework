from __future__ import annotations

import json
import re
import shlex
from datetime import UTC, datetime
from pathlib import Path
from typing import cast

from libtestvim.serde import JsonValue


def vim_string(value: str) -> str:
    return "'" + value.replace("'", "''") + "'"


def shell_join(parts: list[str] | tuple[str, ...]) -> str:
    return " ".join(shlex.quote(part) for part in parts)


def utc_now_iso() -> str:
    return datetime.now(UTC).isoformat()


def slugify_label(value: str) -> str:
    slug = re.sub(r"[^A-Za-z0-9._-]+", "-", value.strip()).strip("-")
    return slug or "run"


def write_json(path: Path, payload: object) -> None:
    from libtestvim.serde import to_python

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(to_python(payload), indent=2) + "\n", encoding="utf-8")


def read_json(path: Path) -> JsonValue:
    return cast(JsonValue, json.loads(path.read_text(encoding="utf-8")))
