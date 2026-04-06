#version 320 es

precision highp float;

in vec2 v_texcoord;

uniform sampler2D tex;
uniform vec2      screen_size;
uniform vec2      pointer_position;

out vec4 f_color;

void main() {
    float d = length(pointer_position * screen_size - v_texcoord * screen_size);
    vec2  t = v_texcoord;
    #define RADIUS 200.0
    if (d < RADIUS) {
        float w = d / RADIUS;
        w  = pow(w, 1.5) - pow(w, 9.0);
        t  = mix(t, pointer_position, 2.0 * w);
        if (d > RADIUS * 0.8) {
            t = mix(t, v_texcoord, pow((d - RADIUS * 0.8) / (RADIUS * 0.2), 0.1));
        }
    }

    f_color = texture(tex, t);
}
