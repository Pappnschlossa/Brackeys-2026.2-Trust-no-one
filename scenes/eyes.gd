extends TextureRect

var average_eyes_position : Vector2
var time_since_last_change : float = 0



func _ready() -> void:
	average_eyes_position = position


func _process(delta: float) -> void:
	time_since_last_change += delta
	if time_since_last_change > 0.1:
		time_since_last_change = 0
		position = average_eyes_position + Vector2(randf_range(-1.5, 1), randf_range(-1.5, 1))
