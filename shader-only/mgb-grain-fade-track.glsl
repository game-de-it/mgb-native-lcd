// One logical GB pixel per output pixel. Feedback stores the responding
// shade in R and a shared grain-visibility envelope in G. The texture itself
// is never translated: it stays attached to the physical screen surface.
#pragma parameter MGB_RESPONSE_DARKEN "MGB pixel darkening speed" 0.55 0.05 1.00 0.01
#pragma parameter MGB_RESPONSE_LIGHTEN "MGB pixel clearing speed" 0.22 0.05 1.00 0.01
#pragma parameter MGB_GRAIN_RECOVERY "MGB grain recovery per frame" 0.88 0.50 0.98 0.01

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
uniform sampler2D PrevTexture;
uniform sampler2D FeedbackTexture;
uniform vec2 TextureSize;
uniform vec2 InputSize;
uniform vec2 PrevTextureSize;
uniform vec2 FeedbackTextureSize;
uniform float MGB_RESPONSE_DARKEN;
uniform float MGB_RESPONSE_LIGHTEN;
uniform float MGB_GRAIN_RECOVERY;

float raw_luma(sampler2D source, vec2 coord, vec2 tex_size) {
    vec2 c = clamp(coord, vec2(0.0), InputSize - vec2(1.0));
    vec3 rgb = texture2D(source, (c + 0.5) / tex_size).rgb;
    return dot(rgb, vec3(0.2126, 0.7152, 0.0722));
}

float matching_cost(vec2 previous_offset) {
    float cost = 0.0;
    // One translation for the whole frame keeps grain coordinates one-to-one.
    // A local best match let several cells inherit one seed, making streaks.
    for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 4; col++) {
            vec2 p = vec2(20.0 + 40.0 * float(col),
                          26.0 + 90.0 * float(row));
            cost += abs(raw_luma(Texture, p, TextureSize) -
                        raw_luma(PrevTexture, p + previous_offset,
                                 PrevTextureSize));
        }
    }
    return cost + 0.01 * (abs(previous_offset.x) + abs(previous_offset.y));
}

void main() {
    vec2 cell = floor(tex_coord * TextureSize);
    float current = raw_luma(Texture, cell, TextureSize);
    vec4 prior = texture2D(FeedbackTexture,
                           (cell + 0.5) / FeedbackTextureSize);
    bool valid = prior.a > 0.5;
    float old_signal = valid ? prior.r : current;
    float speed = current < old_signal
        ? MGB_RESPONSE_DARKEN : MGB_RESPONSE_LIGHTEN;
    float signal = mix(old_signal, current, speed);
    if (abs(signal - current) < 1.0 / 255.0) signal = current;

    vec2 best_offset = vec2(0.0);
    float best_cost = matching_cost(best_offset);
    float zero_cost = best_cost;
    vec2 trial = vec2(1.0, 0.0);
    float cost = matching_cost(trial);
    if (cost < best_cost) { best_cost = cost; best_offset = trial; }
    trial = vec2(-1.0, 0.0);
    cost = matching_cost(trial);
    if (cost < best_cost) { best_cost = cost; best_offset = trial; }
    trial = vec2(0.0, 1.0);
    cost = matching_cost(trial);
    if (cost < best_cost) { best_cost = cost; best_offset = trial; }
    trial = vec2(0.0, -1.0);
    cost = matching_cost(trial);
    if (cost < best_cost) { best_cost = cost; best_offset = trial; }
    trial = vec2(2.0, 0.0);
    cost = matching_cost(trial);
    if (cost < best_cost) { best_cost = cost; best_offset = trial; }
    trial = vec2(-2.0, 0.0);
    cost = matching_cost(trial);
    if (cost < best_cost) { best_cost = cost; best_offset = trial; }
    trial = vec2(0.0, 2.0);
    cost = matching_cost(trial);
    if (cost < best_cost) { best_cost = cost; best_offset = trial; }
    trial = vec2(0.0, -2.0);
    cost = matching_cost(trial);
    if (cost < best_cost) { best_cost = cost; best_offset = trial; }

    bool scrolling = best_cost < zero_cost - 0.50 && best_cost < 2.0;

    // Motion is computed once conceptually for the whole source frame.
    // Every cell uses the same probes, so G is uniform across the panel.
    vec4 global_history = texture2D(FeedbackTexture,
                                     vec2(0.5) / FeedbackTextureSize);
    float frame_change = clamp((zero_cost / 8.0 - 0.005) * 18.0,
                               0.0, 1.0);
    float motion_now = scrolling ? 1.0 : frame_change;
    float old_motion = global_history.a > 0.5 ? global_history.g : 0.0;
    float motion = max(motion_now, old_motion * MGB_GRAIN_RECOVERY);
    if (motion < 1.0 / 255.0) motion = 0.0;
    gl_FragColor = vec4(signal, motion, 0.0, 1.0);
}
#endif
