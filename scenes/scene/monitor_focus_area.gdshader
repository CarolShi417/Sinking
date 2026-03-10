shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	//COLOR = vec4(texture(screen_texture, SCREEN_UV).rgb, texture(TEXTURE, UV).a);
	vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
	float alpha_mask = texture(TEXTURE, UV).a;

	COLOR = vec4(screen_color, alpha_mask);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
