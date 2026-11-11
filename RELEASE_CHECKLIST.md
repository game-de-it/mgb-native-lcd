# MGB Native LCD v0.1.0 release checklist

This checklist records the v0.1.0 publication checks. Device-specific limitations that remain open are stated in the README and release notes.

- [x] Identify the current two-pass preset and keep its three files together in `shader-only/`.
- [x] Prepare a separate `pixel2/` package with a relative-path preset, the tested rotated final pass, and a GB override example; keep Standard as the default package.
- [x] Build versioned Standard and Pixel2 ZIPs in `dist/`; verify each preset's two shader references and feedback pass inside its own archive.
- [x] Document **RetroArch Integer Scale ON** as required in both main READMEs and both shader-only READMEs.
- [x] Document the GL/GLSL driver, four-shade input, palette/colorization requirement, and Pixel2 exception.
- [x] Preserve the static-model and temporal-investigation notes separately from the current install instructions.
- [x] Add the MIT License to the repository and both shader archives.
- [x] Add the user-selected physical comparison photo and three RetroArch screenshots to both main READMEs; strip EXIF/XMP from the photo copy and check the PNGs for EXIF.
- [x] Clarify that the MIT License does not cover game artwork shown in the comparison images.
- [x] Confirm the photo and screenshot captions against the selected images.
- [x] Document all 16 RA shader parameters in English and Japanese and include both guides in each ZIP.
- [x] Confirmed Pocket Block appearance and motion, plus Pixel2 upright display after a frontend relaunch, during device development.
- [x] Verify bilingual local links, ZIP-internal links, preset-relative shader paths, and exact asset checksums.
- [x] Generate and verify `SHA256SUMS` and record v0.1.0 in `CHANGELOG.md`.
- [ ] Create the public GitHub repository/release and read back its asset names, metadata, and checksums.

## Further device checks

- [ ] Test each extracted release ZIP as a clean install on its target device; the packaged GLSL matches the previously accepted shader code, but the ZIP installation route has not been physically retested.
- [ ] Verify ANBERNIC stockOS Integer Scale ON and inspect the grid after relaunch.
- [ ] Measure Pixel2 motion quality, performance, and complete audio/input/exit routes separately.
