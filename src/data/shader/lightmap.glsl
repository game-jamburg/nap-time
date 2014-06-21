extern number radius;
// extern number sampling;
extern sampler2D shadowmap;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
    float dx = radius - pixel_coords.x;
    float dy = radius - pixel_coords.y;

    float alpha = atan(dy, dx);
    float tx = (alpha / 3.1415927) * 0.5 + 0.5;

    float d = sqrt(dx * dx + dy * dy);
    vec4 shadowV = texture2D(shadowmap, vec2(tx, 0.5));
    float shadow = shadowV.r + shadowV.g * 256 + shadowV.b * 256 * 256;
    shadow = shadow * 256 / 1000.0;

    float diff = shadow - d;

    float a = mix(0, 1, clamp(diff / 2 + 0.5, 0, 1));

    // float dd = d - range;
    // float aa = sin((clamp(dd, -blur, blur) / (blur * 2)) * 3.1415);

    // return vec4(color.rgb, 1 - a * (1 - aa)); // sin((a - 0.5) * 3.1415)); // mix(a, 0, 1.0 / 255));
    return vec4(a, a, a, 1); // sin((a - 0.5) * 3.1415)); // mix(a, 0, 1.0 / 255));
}
