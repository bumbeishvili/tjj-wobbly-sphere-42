attribute vec4 tangent;
#include ../includes/simplexNoise4d.glsl
varying vec2 vUv;
varying float vWobble;

uniform float uTime;
uniform float uTimeFrequency;
uniform float uStrength;
uniform float uPositionFrequency;

uniform float uWarpPositionFrequency;
uniform float uWarpTimeFrequency;
uniform float uWarpStrength;

float getWobble(vec3 position) {
    vec3 warpedPosition = position;
    warpedPosition += simplexNoise4d(vec4(position * uWarpPositionFrequency, uTime * uWarpTimeFrequency)) * uWarpStrength;
    float wobble = simplexNoise4d(vec4(warpedPosition * uPositionFrequency, uTime * uTimeFrequency)) * uStrength;
    return wobble;
}
void main() {
    vec3 biTangent = cross(normal, tangent.xyz);
    // Neighbours positions
    float shift = 0.01;
    vec3 positionA = csm_Position + tangent.xyz * shift;
    vec3 positionB = csm_Position + biTangent * shift;

  // Wobble
    float wobble = getWobble(csm_Position);

    csm_Position += wobble * normal;
    positionA += getWobble(positionA) * normal;
    positionB += getWobble(positionB) * normal; 

    // compute normal 
    vec3 toA = normalize(positionA - csm_Position);
    vec3 toB = normalize(positionB - csm_Position);
    csm_Normal = cross(toA, toB);

    // varyings 
    vWobble = wobble/uStrength;
}