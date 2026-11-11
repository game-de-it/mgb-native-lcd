# RetroArch shader parameters

**English** | [日本語](parameters-ja.md)

These are the adjustable parameters in **MGB Native LCD v0.1.0**. The Standard and plumOS-pixel2 presets expose the same 16 values; Pixel2's output rotation is fixed in its shader code and is not an adjustable parameter. The defaults below come from the GLSL `#pragma parameter` declarations. The RGB gain defaults are also written explicitly in both `.glslp` presets.

Open a GB game, then **Quick Menu → Shaders → Shader Parameters**. Change one value at a time and compare a bright flat area, dark text, the four image edges, and a scrolling scene. Save a new preset if you want the changes to persist. Keep **RetroArch Integer Scale ON**; it is a video setting, not one of these shader parameters.

## Cell grid

| RetroArch label (`ID`) | Default | Range / step | What it changes |
| --- | ---: | --- | --- |
| MGB active width (`MGB_APERTURE_X`) | `0.86` | `0.70–1.00 / 0.01` | Width of each active cell in source-pixel units. A larger value narrows the vertical gaps; a smaller value widens them. |
| MGB active height (`MGB_APERTURE_Y`) | `0.96` | `0.70–1.00 / 0.01` | Height of each active cell. A larger value narrows the horizontal gaps. |
| MGB edge variation (`MGB_EDGE_VARIATION`) | `0.015` | `0.00–0.05 / 0.001` | Fixed irregularity of cell edges. The actual shift on each axis is about ± half this value. `0` makes the edges regular. |

The grid position is calculated from source-cell coordinates. These parameters change the cell shape, not RetroArch's output scale.

## Surface and brightest-shade grid

| RetroArch label (`ID`) | Default | Range / step | What it changes |
| --- | ---: | --- | --- |
| MGB dark-cell gray roughness (`MGB_ROUGHNESS`) | `0.100` | `0.00–0.20 / 0.005` | Amplitude of neutral grain in the three darker GB shades. `0` removes that dark-area grain. |
| MGB light grain between face and gap (`MGB_LIGHT_GRAIN_FRACTION`) | `0.50` | `0.00–1.00 / 0.05` | Amount of grain on the brightest shade's active face, as a fraction of the light-grid parameter. It also participates in the brightness compensation that preserves the bright area's average. |
| MGB light-cell imprint (`MGB_OFF_GRID`) | `0.060` | `0.000–0.100 / 0.005` | Strength of the faint grid in the brightest GB shade. Raising it increases the face-to-gap contrast and the available bright-area grain range. `0` removes both this imprint and its associated bright grain. |

The brightest background is one of the GB's four input shades. Its grain is deliberately confined between its darker face and brighter gap. The grain pattern is fixed to the screen; during motion a separate parameter reduces its contrast.

## Reflected color

| RetroArch label (`ID`) | Default | Range / step | What it changes |
| --- | ---: | --- | --- |
| MGB reflected red gain (`MGB_TINT_R`) | `0.82` | `0.30–1.20 / 0.01` | Multiplies the final reflected red channel. |
| MGB reflected green gain (`MGB_TINT_G`) | `0.83` | `0.20–1.20 / 0.01` | Multiplies the final reflected green channel. |
| MGB reflected blue gain (`MGB_TINT_B`) | `0.71` | `0.10–1.20 / 0.01` | Multiplies the final reflected blue channel. |

Changing one gain affects both color balance and luminance. These values were visually tuned on Pocket Block; they are not measured MGB spectral reflectances. Disable the core's DMG palette/colorization before tuning them.

## Recessed bezel shadow

| RetroArch label (`ID`) | Default | Range / step | What it changes |
| --- | ---: | --- | --- |
| MGB side shadow reach (cells) (`MGB_SHADOW_X`) | `8.0` | `0.0–12.0 / 0.5` | Inward falloff distance at the left and right edges, measured in GB source cells. Larger values spread the shadow farther inward. |
| MGB top/bottom shadow reach (cells) (`MGB_SHADOW_Y`) | `8.0` | `0.0–16.0 / 0.5` | Inward falloff distance at the top and bottom edges. |
| MGB bezel shadow strength (`MGB_SHADOW_STRENGTH`) | `0.60` | `0.00–0.75 / 0.01` | Overall edge darkening. `0` disables it. The code makes the top 1.20× and the right 0.90× this value. |

The edge profile fades continuously; a reach of `8` cells is its falloff scale, not a hard border. These values describe a visual impression of depth, not measured millimeters.

## Temporal response and grain visibility

| RetroArch label (`ID`) | Default | Range / step | What it changes |
| --- | ---: | --- | --- |
| MGB pixel darkening speed (`MGB_RESPONSE_DARKEN`) | `0.55` | `0.05–1.00 / 0.01` | Fraction of the remaining signal change applied per frame when a cell becomes darker. Higher values settle faster and leave less darkening trail. |
| MGB pixel clearing speed (`MGB_RESPONSE_LIGHTEN`) | `0.22` | `0.05–1.00 / 0.01` | Per-frame fraction when a cell becomes brighter. Lower values keep a longer clearing trail. |
| MGB grain recovery per frame (`MGB_GRAIN_RECOVERY`) | `0.88` | `0.50–0.98 / 0.01` | Multiplier for the motion envelope after motion stops. **Higher** values keep the grain subdued for longer; lower values restore it sooner. |
| MGB grain loss during scrolling (`MGB_MOTION_GRAIN_FADE`) | `1.00` | `0.00–1.00 / 0.05` | How strongly detected motion suppresses grain contrast. `0` leaves the grain fully visible during scrolling; `1` gives the accepted maximum suppression. It does not move the grain. |

The first two speeds affect the four-shade image response. The latter two affect the visibility of the stationary surface texture. Motion detection itself is fixed in the shader and is not exposed as a parameter. At `1.00`, a response speed applies the target signal in one frame; at lower values it approaches the target over multiple frames.

## Reset and scope

If adjustments become hard to compare, reload the original preset to restore its defaults. On another display, adjust the RGB gains before changing the grid geometry or temporal response. The [model description](../README.md#display-model) and [release notes](https://github.com/game-de-it/mgb-native-lcd/releases/tag/v0.1.0) explain the intended appearance and device scope.
