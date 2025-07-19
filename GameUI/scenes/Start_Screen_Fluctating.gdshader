shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float speedMultiplier = 1.0;
	//vec2 movingUV = vec2(UV.x + (TIME * speedMultiplier), UV.y);
	vec4 DottedLine = texture(TEXTURE,UV);
	COLOR = DottedLine;
	COLOR.a *= abs(sin(TIME * speedMultiplier));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
