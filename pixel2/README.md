# MGB Native LCD for plumOS-pixel2

**English** | [日本語](README_JA.md)

This is the **Pixel2-specific** build of MGB Native LCD. Use the [standard package](https://github.com/game-de-it/mgb-native-lcd/releases/tag/v0.1.0) on other devices and operating systems. Pixel2's GL/FBO output needed a final-pass vertex rotation to appear upright on its 480 × 640 panel. The optical colors, grain, shadow, and temporal response are otherwise the same as the standard shader.

## Files

- `mgb-grain-fade-pixel2.glslp`: two-pass preset with relative shader paths.
- `mgb-grain-fade-track.glsl`: unchanged temporal pass from the standard package.
- `mgb-grain-fade-draw-pixel2.glsl`: final pass with the Pixel2 vertex transform.
- `GB.cfg.example`: settings that were needed for GB launch on the tested plumOS-pixel2. It is an example, not an automatic installer.

## Install on plumOS-pixel2

1. Keep the preset and both `.glsl` files together. Copy them to a RetroArch shader directory; the tested layout used `/mnt/plumos/config/shaders/mgb-native-lcd/`.
2. Use a GL/OpenGL-compatible video driver and a 160 × 144, four-shade GB image. Disable DMG palette/colorization in the GB core.
3. **Turn on Settings → Video → Scaling → Integer Scale.** The key is `video_scale_integer = "true"`. This is required to avoid uneven grid cells and the moiré observed on Pixel2.
4. Load `mgb-grain-fade-pixel2.glslp` from the RetroArch shader menu. It is the Pixel2 preset; do not select the standard preset on this device.
5. For automatic GB startup, back up existing Gambatte/GB overrides. Save the active shader as a GB content-directory preset, then merge the applicable lines from `GB.cfg.example` into the GB-specific configuration. On the tested plumOS-pixel2, `video_shader_delay = "2"` prevented a black screen at startup; `video_rotation = "0"` left rotation to this shader.
6. Return to the frontend, launch a GB game again, and check that the image is upright from the first rendered frame, integer-scaled, and free of moiré. Verify that GBC and other systems are not assigned this Pixel2 GB preset.

The included [parameter guide](PARAMETERS.md) explains all 16 controls; [日本語版](PARAMETERS_JA.md) is also included. The Pixel2 rotation is fixed and is not among those controls.

The example config contains `aspect_ratio_index = "24"` because that was part of the tested full-screen Pixel2 setup. Merge settings deliberately; replacing an existing override wholesale could discard unrelated choices. The shader cannot set Integer Scale or the application delay by itself.

## Scope and limitations

The rotation is a workaround for the tested plumOS-pixel2 RetroArch GL/FBO path. It should not be applied to Pocket Block, macOS, plumOS-MF, ANBERNIC stockOS, or other ordinary upright outputs. Pixel2 was visually checked after a fresh frontend launch; motion quality, performance, and every audio/input/exit route were not separately measured there. See the [deployment record](https://github.com/game-de-it/mgb-native-lcd/blob/main/docs/pixel2-deployment-ja.md).

## License

The shader source and project-authored documentation are under the [MIT License](LICENSE), © 2026 game-de-it.
