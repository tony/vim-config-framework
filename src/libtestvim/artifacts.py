from __future__ import annotations

import uuid
from collections.abc import Sequence
from pathlib import Path

from libtestvim.models import ArtifactBundle
from libtestvim.util import slugify_label, utc_now_iso, write_json


def new_run_id(label: str) -> str:
    timestamp = utc_now_iso().replace(":", "").replace("-", "")
    return f"{timestamp}-{slugify_label(label)}-{uuid.uuid4().hex[:8]}"


def create_bundle(root: Path, category: str, label: str) -> ArtifactBundle:
    run_id = new_run_id(label)
    bundle_root = root / category / run_id
    bundle_root.mkdir(parents=True, exist_ok=True)
    return ArtifactBundle(run_id=run_id, root=bundle_root, files={})


def bundle_path(bundle: ArtifactBundle, relative: str) -> Path:
    path = bundle.root / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    bundle.files[relative] = path
    return path


def write_bundle_json(bundle: ArtifactBundle, relative: str, payload: object) -> Path:
    path = bundle_path(bundle, relative)
    write_json(path, payload)
    return path


def write_bundle_text(bundle: ArtifactBundle, relative: str, text: str) -> Path:
    path = bundle_path(bundle, relative)
    path.write_text(text, encoding="utf-8")
    return path


def append_jsonl(path: Path, payloads: Sequence[object]) -> None:
    from libtestvim.serde import to_jsonl

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as handle:
        handle.write(to_jsonl(payloads))
