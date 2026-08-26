extends Control

func _on_door_button_mouse_entered() -> void:
	get_node("Texture").material.set_shader_parameter("width", 5.0)

func _on_door_button_mouse_exited() -> void:
	get_node("Texture").material.set_shader_parameter("width", 0.0)
