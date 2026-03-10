shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;


void fragment() {
	//vec3 screen = texture(screen_texture, SCREEN_UV).rgb;
    //float mask = texture(TEXTURE, UV).a;
//
    //if (mask < 0.1) {
        //COLOR = vec4(0.0,0.0,0.0,0.0);
    //} else {
        //COLOR = vec4(screen,1.0);
    //}
	COLOR = vec4(texture(screen_texture, SCREEN_UV).rgb, texture(TEXTURE, UV).a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
