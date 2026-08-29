extends AnimatedSprite2D

func _on_eyes_button_pressed() -> void:
	play("wink")
	if not get_node("SFX").playing:
		get_node("SFX").play()
