#!/usr/bin/env python3
"""Build the two allowlisted MGB Native LCD v0.1.0 release archives."""

from hashlib import sha256
from pathlib import Path
import re
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo


ROOT = Path(__file__).resolve().parents[1]
DIST = ROOT / "dist"
VERSION = "v0.1.0"
PACKAGES = {
    "Standard": (
        "shader-only",
        (
            "LICENSE",
            "README.md",
            "README_JA.md",
            "PARAMETERS.md",
            "PARAMETERS_JA.md",
            "mgb-grain-fade.glslp",
            "mgb-grain-fade-track.glsl",
            "mgb-grain-fade-draw.glsl",
        ),
    ),
    "Pixel2": (
        "pixel2",
        (
            "LICENSE",
            "README.md",
            "README_JA.md",
            "PARAMETERS.md",
            "PARAMETERS_JA.md",
            "mgb-grain-fade-pixel2.glslp",
            "mgb-grain-fade-track.glsl",
            "mgb-grain-fade-draw-pixel2.glsl",
            "GB.cfg.example",
        ),
    ),
}


def build(name: str, source_dir: str, files: tuple[str, ...]) -> tuple[str, str]:
    archive_name = f"MGB-Native-LCD-{name}-{VERSION}.zip"
    archive_path = DIST / archive_name
    package_dir = archive_path.stem
    with ZipFile(archive_path, "w") as archive:
        for filename in files:
            content = (ROOT / source_dir / filename).read_bytes()
            info = ZipInfo(f"{package_dir}/{filename}", (2026, 11, 12, 0, 0, 0))
            info.compress_type = ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            archive.writestr(info, content)

    with ZipFile(archive_path) as archive:
        if archive.testzip() is not None or len(archive.namelist()) != len(files):
            raise ValueError(f"Invalid archive: {archive_name}")
        for filename in files:
            member = f"{package_dir}/{filename}"
            if archive.read(member) != (ROOT / source_dir / filename).read_bytes():
                raise ValueError(f"Archive member differs: {member}")
        presets = [filename for filename in files if filename.endswith(".glslp")]
        if len(presets) != 1:
            raise ValueError(f"Expected one preset in {archive_name}")
        preset = archive.read(f"{package_dir}/{presets[0]}").decode()
        shader_refs = re.findall(r'^shader\d+ = "([^"]+)"', preset, re.MULTILINE)
        if len(shader_refs) != 2 or any(ref not in files for ref in shader_refs):
            raise ValueError(f"Missing shader reference in {archive_name}")
        if 'feedback_pass = "0"' not in preset:
            raise ValueError(f"Missing feedback pass in {archive_name}")

    return archive_name, sha256(archive_path.read_bytes()).hexdigest()


def main() -> None:
    DIST.mkdir(exist_ok=True)
    checksums = [build(name, *manifest) for name, manifest in PACKAGES.items()]
    (DIST / "SHA256SUMS").write_text(
        "".join(f"{digest}  {name}\n" for name, digest in checksums),
        encoding="ascii",
    )
    for name, digest in checksums:
        print(f"{digest}  {name}")


if __name__ == "__main__":
    main()
