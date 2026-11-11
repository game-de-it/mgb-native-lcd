// MGB reflective LCD hypothesis: a light reflecting gap surrounds each dark cell.
#pragma parameter MGB_APERTURE_X "MGB active width" 0.86 0.70 1.00 0.01
#pragma parameter MGB_APERTURE_Y "MGB active height" 0.96 0.70 1.00 0.01
#pragma parameter MGB_ROUGHNESS "MGB dark-cell gray roughness" 0.100 0.00 0.20 0.005
#pragma parameter MGB_LIGHT_GRAIN_FRACTION "MGB light grain between face and gap" 0.50 0.00 1.00 0.05
#pragma parameter MGB_EDGE_VARIATION "MGB edge variation" 0.015 0.00 0.05 0.001
#pragma parameter MGB_OFF_GRID "MGB light-cell imprint" 0.060 0.000 0.100 0.005
#pragma parameter MGB_TINT_R "MGB reflected red gain" 0.82 0.30 1.20 0.01
#pragma parameter MGB_TINT_G "MGB reflected green gain" 0.64 0.20 1.20 0.01
#pragma parameter MGB_TINT_B "MGB reflected blue gain" 0.51 0.10 1.20 0.01
#pragma parameter MGB_SHADOW_X "MGB side shadow reach (cells)" 8.0 0.0 12.0 0.5
#pragma parameter MGB_SHADOW_Y "MGB top/bottom shadow reach (cells)" 8.0 0.0 16.0 0.5
#pragma parameter MGB_SHADOW_STRENGTH "MGB bezel shadow strength" 0.60 0.0 0.75 0.01

#if defined(VERTEX)
attribute vec4 VertexCoord;
attribute vec4 TexCoord;
uniform mat4 MVPMatrix;
varying vec2 tex_coord;
void main() {
    gl_Position = MVPMatrix * VertexCoord;
    tex_coord = TexCoord.xy;
}
#elif defined(FRAGMENT)
#ifdef GL_ES
precision highp float;
#endif
varying vec2 tex_coord;
uniform sampler2D Texture;
uniform vec2 TextureSize;
uniform vec2 InputSize;
uniform vec2 OutputSize;
uniform float MGB_APERTURE_X;
uniform float MGB_APERTURE_Y;
uniform float MGB_ROUGHNESS;
uniform float MGB_LIGHT_GRAIN_FRACTION;
uniform float MGB_EDGE_VARIATION;
uniform float MGB_OFF_GRID;
uniform float MGB_TINT_R;
uniform float MGB_TINT_G;
uniform float MGB_TINT_B;
uniform float MGB_SHADOW_X;
uniform float MGB_SHADOW_Y;
uniform float MGB_SHADOW_STRENGTH;

float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float edge_light(float distance_cells, float reach_cells,
                 float strength) {
    // A rational falloff has no visible inner boundary. At half the reach
    // it has half strength, and it continues to fade farther inward.
    float scaled = max(distance_cells, 0.0) /
                   max(0.5 * reach_cells, 0.001);
    float falloff = 1.0 / (1.0 + scaled * scaled);
    return 1.0 - strength * falloff;
}

vec3 shade_color(float luma) {
    // Display RGB proxies, pending linear RAW measurements of the four states.
    if (luma > 0.82) return vec3(0.67, 0.71, 0.62);
    if (luma > 0.48) return vec3(0.54, 0.57, 0.50);
    if (luma > 0.15) return vec3(0.40, 0.43, 0.37);
    return vec3(0.27, 0.29, 0.25);
}

void main() {
    vec2 source_xy = tex_coord * TextureSize;
    vec2 cell = floor(source_xy);
    vec2 phase = fract(source_xy) - 0.5;
    vec2 sample_uv = (cell + 0.5) / TextureSize;
    vec3 source = texture2D(Texture, sample_uv).rgb;
    float luma = dot(source, vec3(0.2126, 0.7152, 0.0722));
    vec3 background = shade_color(1.0);
    vec3 face = shade_color(luma);
    // Even the brightest source shade keeps a weak active-cell imprint.
    // Recenter around the old light shade to preserve its average luminance.
    // The same aperture and edge variation govern light and dark cells.
    if (luma > 0.82) {
        float mean_aperture = MGB_APERTURE_X * MGB_APERTURE_Y;
        background += vec3(MGB_OFF_GRID * mean_aperture);
        // Positive grain has a mean of about 0.5. Lower the face by that
        // mean contribution so the brightest shade keeps its earlier average.
        face -= vec3(MGB_OFF_GRID * (1.0 - mean_aperture +
            0.5 * MGB_LIGHT_GRAIN_FRACTION));
    }

    // A half-output-pixel transition integrates the thin gap at 5x scaling.
    vec2 scale = OutputSize / InputSize;
    vec2 aa = 0.5 / max(scale, vec2(1.0));
    vec2 micro = floor(source_xy * 2.0);
    vec2 jitter = MGB_EDGE_VARIATION * vec2(
        hash21(micro + vec2(11.0, 3.0)) - 0.5,
        hash21(micro + vec2(5.0, 17.0)) - 0.5);
    vec2 radius = 0.5 * vec2(MGB_APERTURE_X, MGB_APERTURE_Y) + jitter;
    vec2 coverage = 1.0 - smoothstep(radius - aa, radius + aa, abs(phase));
    float aperture = coverage.x * coverage.y;

    // Stationary spatial texture, independent of frame count.
    float fine = hash21(micro + vec2(23.0, 41.0)) - 0.5;
    float broad = hash21(floor(source_xy * 0.5) + vec2(19.0, 7.0)) - 0.5;
    // Keep all three visible/darker graphic shades exactly as before.
    // The brightest shade gets an independent surface setting.
    float darkness = luma > 0.82 ? 0.0 : 1.0;
    // Restore the original fine gray grain in the three darker shades.
    // For the brightest shade: face <= grain <= reflecting gap. The grain
    // only raises the face's reflectance, never darkens it or exceeds the gap.
    float dark_grain = 0.75 * fine + 0.25 * broad;
    float light_grain = 0.70 * hash21(micro + vec2(71.0, 89.0)) +
        0.30 * hash21(floor(source_xy * 3.0) + vec2(43.0, 17.0));
    float light_surface = aperture * MGB_OFF_GRID *
        MGB_LIGHT_GRAIN_FRACTION * light_grain;
    float rough = mix(light_surface,
                      MGB_ROUGHNESS * dark_grain, darkness);
    vec3 reflected = mix(background, face, aperture) + vec3(rough);
    // Gains chosen to match the photographed MGB's muted gray-brown palette
    // in direct shader output. The camera's blue cast on the emissive panel
    // is not folded into these values.
    // Apply after the aperture calculation to keep all four shade ratios and
    // the accepted light/dark surface texture formulas intact.
    reflected *= vec3(MGB_TINT_R, MGB_TINT_G, MGB_TINT_B);

    // The LCD sits below its front bezel. Distance is measured in source
    // cells, so the shadow covers the same part of the image at any scale.
    float left = source_xy.x;
    float right = InputSize.x - source_xy.x;
    float top = source_xy.y;
    float bottom = InputSize.y - source_xy.y;
    float shadow = edge_light(left, MGB_SHADOW_X,
                              MGB_SHADOW_STRENGTH) *
                   edge_light(right, MGB_SHADOW_X,
                              0.90 * MGB_SHADOW_STRENGTH) *
                   edge_light(top, MGB_SHADOW_Y,
                              1.20 * MGB_SHADOW_STRENGTH) *
                   edge_light(bottom, MGB_SHADOW_Y,
                              MGB_SHADOW_STRENGTH);
    gl_FragColor = vec4(clamp(reflected * shadow, 0.0, 1.0), 1.0);
}
#endif
