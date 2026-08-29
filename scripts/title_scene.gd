extends Control

signal change_scene
signal add_scene_as_an_overlay

@export var check_button : CheckBox

func _on_start_button_pressed() -> void:
	g.tutorial = check_button.button_pressed
	change_scene.emit("level_scene", "bubble_transition")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
