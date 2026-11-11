# MGB Native LCD shader-only package

**English** | [日本語](README_JA.md)

This is the **standard/default** two-pass GLSL package for ordinary compatible devices and operating systems. The release file is `MGB-Native-LCD-Standard-v0.1.0.zip`. The separate [plumOS-pixel2 package](https://github.com/game-de-it/mgb-native-lcd/releases/tag/v0.1.0) contains that device's rotation workaround. This package does not include RetroArch, a GB core, game files, or device-specific configuration.

## Install

1. Keep `mgb-grain-fade.glslp`, `mgb-grain-fade-track.glsl`, and `mgb-grain-fade-draw.glsl` together with their original names. Copy the directory to a location visible in RetroArch's shader browser.
2. Select a GL/OpenGL-compatible video driver for GLSL and restart RetroArch if it changed.
3. **Turn on Settings → Video → Scaling → Integer Scale.** This is required for correct grid geometry. The config key is `video_scale_integer = "true"`. The preset cannot turn it on. Check core/content/game overrides if the setting reverts.
4. Disable core/frontend DMG palette or GB colorization; use a 160 × 144, four-shade GB image.
5. Load `mgb-grain-fade.glslp` from **Quick Menu → Shaders → Load Preset** and enable shaders. Inspect the active preset after relaunch.

The included [parameter guide](PARAMETERS.md) explains all 16 controls; [日本語版](PARAMETERS_JA.md) is also included.

## Why other devices may differ

- The Pocket Block reference is exact 5× output: 160 × 144 → 800 × 720. Other integer scales keep even cell widths, but fine grain and gaps can differ. Fractional scaling can create moiré.
- The RGB gains were selected for Pocket Block under comparison lighting. Another panel or brightness setting will change the apparent color.
- The two passes require GLSL and feedback-buffer support. A driver that cannot load `.glslp` or provide feedback cannot run the effect.
- The standard shader does not rotate output. Use the separate Pixel2 package only on the tested plumOS-pixel2 GL/FBO path.
- A pre-existing game-specific preset may override the shader configured elsewhere.

Rendering without an error verifies compatibility, not a physical match to the MGB. For the model and device notes, see the [project README](https://github.com/game-de-it/mgb-native-lcd#readme).

## License

The shader source and project-authored documentation are under the [MIT License](LICENSE), © 2026 game-de-it.
