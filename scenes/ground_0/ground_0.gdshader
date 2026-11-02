shader_type canvas_item;

uniform float fade_top : hint_range(0.0, 0.5) = 0.1;
uniform float fade_bottom : hint_range(0.0, 0.5) = 0.1;
// 新增：曲线柔和度，越大越缓
uniform float softness : hint_range(1.0, 4.0) = 2.0;

void fragment() {
    vec2 region_uv = (UV - REGION_RECT.xy) / REGION_RECT.zw;

    float t = smoothstep(0.0, fade_top, region_uv.y);
    float b = smoothstep(0.0, fade_bottom, 1.0 - region_uv.y);

    // 用 pow 把曲线压得更缓，过渡更绵
    t = pow(t, softness);
    b = pow(b, softness);

    float edge_fade = min(t, b);
    COLOR.a *= edge_fade;
}