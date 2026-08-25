extends Control

signal change_scene
signal add_scene_as_an_overlay

@export var door_node : Control


func _on_shop_exit_button_pressed() -> void:
	change_scene.emit("level_scene")


func _on_shop_exit_button_mouse_entered() -> void:
	door_node.get_node("Texture").material.set_shader_parameter("width", 5.0)


func _on_shop_exit_button_mouse_exited() -> void:
	door_node.get_node("Texture").material.set_shader_parameter("width", 0.0)
