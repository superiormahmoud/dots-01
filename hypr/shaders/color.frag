#version 300 es
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;

// sRGB -> native panel primaries (BOE 0x0687), computed from EDID
const mat3 M = mat3(
     1.0879, -0.0691, -0.0202,
    -0.1969,  1.2386, -0.0090,
     0.1043, -0.1660,  1.0222
);

const float STRENGTH = 0.85;   // 0 = off, 1 = full correction

void main() {
    vec4 c = texture(tex, v_texcoord);
    vec3 lin = pow(max(c.rgb, 0.0), vec3(2.2));
    vec3 corrected = clamp(M * lin, 0.0, 1.0);
    vec3 outc = pow(mix(lin, corrected, STRENGTH), vec3(1.0 / 2.2));
    fragColor = vec4(outc, c.a);
}
