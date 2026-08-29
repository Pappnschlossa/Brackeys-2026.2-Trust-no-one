shader_type canvas_item;

uniform vec4 hole_rect; // x, y, width, height in UV coordinates
uniform vec4 hole_rect_2;

void fragment() {
	vec4 color = COLOR;

	if (
		UV.x >= hole_rect.x &&
		UV.x <= hole_rect.x + hole_rect.z &&
		UV.y >= hole_rect.y &&
		UV.y <= hole_rect.y + hole_rect.w
	) {
		color.a = 0.0;
	}

	if (
		UV.x >= hole_rect_2.x &&
		UV.x <= hole_rect_2.x + hole_rect_2.z &&
		UV.y >= hole_rect_2.y &&
		UV.y <= hole_rect_2.y + hole_rect_2.w
	) {
		color.a = 0.0;
	}

	COLOR = color;
}