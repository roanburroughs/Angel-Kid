//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 u_mainColor;
uniform vec3 u_blackColor;

float luminance(vec3 color) {
    return dot(color, vec3(0.299, 0.587, 0.114));
}

void main() {
    vec4 texel = texture2D(gm_BaseTexture, v_vTexcoord);
    float amount = clamp(luminance(texel.rgb), 0.0, 1.0);
    vec3 mapped = mix(u_blackColor, u_mainColor, amount);

    gl_FragColor = vec4(mapped, texel.a) * v_vColour;
}