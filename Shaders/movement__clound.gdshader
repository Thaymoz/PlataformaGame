shader_type canvas_item;

// criamos um parametro de movimentaçao fixa do objeto
uniform float move_speed = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.

	// codigo para criar a movimentaçao aqui ele soma a velocidade no eixo
	// x pois ele quer q ande para o X
	COLOR= texture(TEXTURE, vec2(UV.x + TIME*move_speed,UV.y));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
