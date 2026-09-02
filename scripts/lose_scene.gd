extends Control

signal change_scene
signal remove_overlay
signal add_scene_as_an_overlay


func _on_retry_button_pressed() -> void:
	g.reinitialize()
	g.tutorial = false
	g.current_items = ["LIFE_POTION", "EMPTY", "EMPTY", "EMPTY"]
	change_scene.emit("level_scene", "bubble_transition")


func _on_main_menu_button_pressed() -> void:
	change_scene.emit("title_scene", "bubble_transition")
