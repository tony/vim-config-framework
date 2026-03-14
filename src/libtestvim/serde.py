from __future__ import annotations

from collections.abc import Iterable
from functools import cache
from typing import TypeVar, cast

from pydantic import TypeAdapter

type JsonPrimitive = None | bool | int | float | str
type JsonValue = JsonPrimitive | list[JsonValue] | dict[str, JsonValue]
type JsonObject = dict[str, JsonValue]

ValidatedT = TypeVar("ValidatedT")


@cache
def _adapter(type_: object) -> TypeAdapter[object]:
    return cast(TypeAdapter[object], TypeAdapter(type_))


def to_python(value: object) -> JsonValue:
    return cast(JsonValue, _adapter(type(value)).dump_python(value, mode="json"))


def to_json_bytes(value: object, *, indent: int | None = None) -> bytes:
    return _adapter(type(value)).dump_json(value, indent=indent)


def to_json(value: object, *, indent: int | None = None) -> str:
    return to_json_bytes(value, indent=indent).decode("utf-8")


def to_jsonl(values: Iterable[object]) -> str:
    return "\n".join(to_json(value) for value in values) + "\n"


def from_python(type_: object, value: object) -> ValidatedT:
    return cast(ValidatedT, _adapter(type_).validate_python(value))


def from_json(type_: object, value: str | bytes | bytearray) -> ValidatedT:
    return cast(ValidatedT, _adapter(type_).validate_json(value))


def json_schema(type_: object) -> JsonObject:
    return cast(JsonObject, _adapter(type_).json_schema())
