# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "tomlkit==0.13.3",
# ]
# ///

import copy
import os
import stat
import sys
import tempfile
from collections.abc import MutableMapping
from pathlib import Path

import tomlkit


def merge(
    destination: MutableMapping[str, object], source: MutableMapping[str, object]
) -> None:
    for key, source_value in source.items():
        destination_value = destination.get(key)
        if isinstance(destination_value, MutableMapping) and isinstance(
            source_value, MutableMapping
        ):
            merge(destination_value, source_value)
        else:
            destination[key] = copy.deepcopy(source_value)


def write_atomic(path: Path, contents: str, file_mode: int) -> None:
    file_descriptor, temporary_name = tempfile.mkstemp(
        dir=path.parent, prefix=f".{path.name}."
    )

    try:
        with os.fdopen(file_descriptor, "w") as temporary_file:
            os.fchmod(temporary_file.fileno(), file_mode)
            temporary_file.write(contents)
            temporary_file.flush()
            os.fsync(temporary_file.fileno())
        os.replace(temporary_name, path)
    except BaseException:
        Path(temporary_name).unlink(missing_ok=True)
        raise


def main() -> int:
    if len(sys.argv) != 3:
        print(
            f"usage: {Path(sys.argv[0]).name} SOURCE_CONFIG DESTINATION_CONFIG",
            file=sys.stderr,
        )
        return 2

    source_path = Path(sys.argv[1])
    destination_path = Path(sys.argv[2])
    source_text = source_path.read_text()
    source_document = tomlkit.loads(source_text)

    if destination_path.is_symlink():
        print(f"refusing to modify symlink: {destination_path}", file=sys.stderr)
        return 1

    destination_path.parent.mkdir(parents=True, exist_ok=True)

    if destination_path.exists():
        destination_text = destination_path.read_text()
        destination_document = tomlkit.loads(destination_text)
        file_mode = stat.S_IMODE(destination_path.stat().st_mode)
        merge(destination_document, source_document)
        merged_text = tomlkit.dumps(destination_document)
    else:
        destination_text = ""
        merged_text = source_text
        file_mode = 0o600

    if merged_text != destination_text:
        write_atomic(destination_path, merged_text, file_mode)
        print(f"updated {destination_path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
