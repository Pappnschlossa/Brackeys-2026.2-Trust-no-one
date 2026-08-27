extends MarginContainer

func _ready() -> void:
	get_node("Number/Texture").material = get_node("Number/Texture").material.duplicate()

func _on_button_mouse_entered() -> void:
	get_node("Number/Texture").material.set_shader_parameter("width", 5.0)


func _on_button_mouse_exited() -> void:
	get_node("Number/Texture").material.set_shader_parameter("width", 0.0)
