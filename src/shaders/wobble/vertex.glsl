
#include ../includes/simplexNoise4d.glsl
varying vec2 vUv;
void main() {
    //csm_Position.y += sin(csm_Position.z * 3.0) * 0.5;

    //vUv = uv;

    float wobble = simplexNoise4d(vec4(csm_Position.xyz, 0.0));
    csm_Position += wobble * normal;

}