# MGB tuning notes

The [project README](../README.md) describes the current preset. The numerical model is a visual approximation; source photographs are not calibrated reflectance measurements.

## Visual targets

- Original MGB cells form a visible vertical and horizontal grid. Their boundaries are not perfectly straight or square.
- The visually blank shade retains a faint grid and fine surface texture; darker shades have more conspicuous neutral grain.
- The grain stays at fixed screen coordinates. Scrolling temporarily reduces its contrast while the four-shade image trails.
- Recessed panel edges have a continuous shadow that lightens inward.

## Parameter provenance

| Quantity | Current default | Basis |
| --- | ---: | --- |
| Active width / height | `0.86` / `0.96` source cells | Visual tuning against MGB close-ups |
| Edge variation | `0.015` peak-to-peak source cells | Visual tuning; no measured surface profile |
| Dark grain amplitude | `0.100` display RGB | User-preferred dark texture |
| Bright-grid parameter | `0.060` display RGB | Preserves the faint light-area grid |
| Bright-grain fraction | `0.50` | Keeps grain between bright cell face and gap |
| Final RGB gains | `(0.82, 0.83, 0.71)` | Same-lighting MGB/Pocket Block visual comparison |
| Bezel reach / strength | `8` source cells / `0.60` | Accepted recessed-panel impression |
| Darken / clear speeds | `0.55` / `0.22` per frame | Accepted visual persistence |
| Motion grain fade / recovery | `1.00` / `0.88` | Scrolling texture visibility review |

## Limits to measure before claiming a physical profile

Uniform illumination, fixed camera exposure and white balance, known display brightness, colorimeter measurements, panel dimensions, and high-frame-rate temporal captures would be needed to turn these visual parameters into physical reflectance, depth, and response-time estimates. The present shader and documentation make no such claim.
