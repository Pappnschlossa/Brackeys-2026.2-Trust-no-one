extends TextureRect

@export var crystal_back : TextureRect
var done : bool = false

func _process(_delta: float) -> void:
	if done:
		return
	global_position = crystal_back.global_position
	done = true
