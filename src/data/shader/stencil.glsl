extern sampler2D stencil;
extern float radius;
extern float sampling;
extern vec2 size;
extern vec2 scale;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
    vec2 screenPos = vec2(gl_FragCoord.x, size.y - gl_FragCoord.y);
    vec2 screenCenter = size / 2;
    vec2 fromScreenCenter = screenPos - screenCenter;

    fromScreenCenter /= scale;

    vec2 mapCenter = vec2(radius * sampling);
    vec2 mapPos = mapCenter + fromScreenCenter;
    vec2 mapPosNorm = mapPos / (2 * radius * sampling);

    vec4 inputPixel = texture2D(texture, texture_coords) * color;
    vec4 replacePixel = vec4(vec3(0.299 * inputPixel.r + 0.587 * inputPixel.g + 0.114 * inputPixel.b) * 0.5, inputPixel.a);

    vec4 stencilPixel = texture2D(stencil, mapPosNorm);
    float lightness = (1-stencilPixel.r) * 0.9;

    return mix(inputPixel, replacePixel, lightness);

}
