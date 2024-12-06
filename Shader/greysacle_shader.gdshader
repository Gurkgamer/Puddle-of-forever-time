shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform bool enable_shader = true;

uniform float brightness = 0.9;
uniform float color_scale = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 c = textureLod(screen_texture, SCREEN_UV, 0).rgb;
	if (enable_shader)
	{
		float temp = dot(c.rgb, vec3(brightness,brightness,brightness));
		COLOR.rgb = vec3(temp);
		COLOR.a = color_scale;
	}
	else
	{
		COLOR.rgb = c.rgb;
		COLOR.a = 1.0;
	}
}