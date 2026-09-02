extends TextureRect

@export var strength : float = 20.0
@export var smoothness : float = 3.0

var original_position: Vector2

func _ready():
	original_position = position

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var screen_size = get_viewport_rect().size

	# Convert mouse position to -1 ... 1
	var mouse_offset = (mouse_pos / screen_size - Vector2(0.5, 0.5)) * 2.0

	# Target position
	var target = original_position + mouse_offset * strength

	# Smooth movement
	position = position.lerp(target, smoothness * delta)
