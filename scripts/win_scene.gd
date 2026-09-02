extends Control

signal change_scene
signal add_scene_as_an_overlay

func _ready() -> void:
	g.erase_save_file()
	$DialogBox/CollectedText.text = "\n\n\n\n\n\n\n\n\n[font_size=50]	[/font_size]\n[font_size=23]You collected %s coins out of 223 during this run![/font_size]" % g.total_coins_collected


func _on_main_menu_button_pressed() -> void:
	change_scene.emit("title_scene", "bubble_transition")

func _on_retry_button_pressed() -> void:
	g.reinitialize()
	g.tutorial = false
	change_scene.emit("level_scene", "bubble_transition")
