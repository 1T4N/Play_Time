shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float speedMultiplier = 0.25;
	vec2 movingUV = vec2(UV.x + (TIME * speedMultiplier), UV.y);
	vec4 DottedLine = texture(TEXTURE,movingUV);
	COLOR = DottedLine;
	COLOR.a *= 0.5;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
