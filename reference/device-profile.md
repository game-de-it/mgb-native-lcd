# Device profile and observed inputs

## Reference

- Target: original Game Boy Pocket (MGB) reflective LCD, photographed under varying light. Camera white balance, glare, panel angle, and reflections are uncontrolled.
- Source: 160 × 144 GB frame with four input shades. The visually blank background is the brightest shade, not a fifth state.
- Main tuning display: KONKR Pocket Block, 800 × 720 GB viewport (exact 5×), RetroArch GLSL/GL, Gambatte. Brightness and lighting still affect the color judgment.
- Source-frame capture: [`docs/images/shader-off.png`](../docs/images/shader-off.png). This is a digital RetroArch screenshot, not a panel photograph. It contains game artwork, whose original rights are unaffected by the shader's MIT License.

## Display settings required for reproduction

| Item | Value | Reason |
| --- | --- | --- |
| RetroArch Integer Scale | ON (`video_scale_integer = "true"`) | Uniform cell width and no scaling moiré |
| GB source | 160 × 144, four shades | Model's cell coordinates and color states |
| GB palette/colorization | OFF | Avoid applying the MGB color model over a DMG palette |
| Video shader path | `mgb-grain-fade.glslp` with both `.glsl` files | Two-pass GLSL with temporal feedback |
| Video driver | GL/OpenGL-compatible | GLSL preset support |

The shader preset itself cannot change RetroArch's integer-scale option. Content, core, or game overrides may change it after startup. The accepted Pocket Block scale does not guarantee identical texture or color on other output resolutions.

## Device observations

- Pocket Block: static appearance, color, shadow, and scrolling grain response visually accepted.
- macOS RetroArch GL: original two-pass preset displayed upright.
- plumOS-MF: original preset displayed at integer scale after shader browser and configuration paths were fixed.
- ANBERNIC stockOS: displayed after disabling Gambatte's conflicting DMG colorization. Integer Scale ON was not separately verified.
- plumOS-pixel2: uses the separate `../pixel2/` package with final-pass rotation; delayed application and Integer Scale ON are also needed. The standard preset is not its deployment preset.
- plumOS-MMF: tested RetroArch build could not execute GLSL.

See the device-specific records in `../docs/` for diagnostic details and limitations. These are observations from the tested setups, not a support matrix for all firmware revisions.
