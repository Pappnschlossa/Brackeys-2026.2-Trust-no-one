extends Control

signal change_scene
signal add_scene_as_an_overlay

@export var check_button : CheckBox
@export var check_button_text : RichTextLabel
@export var continue_panel : PanelContainer
@export var error_text : RichTextLabel

func _ready() -> void:
	check_button.show()
	check_button_text.show()
	continue_panel.hide()
	if FileAccess.file_exists(g.SAVE_PATH):
		var save_file = FileAccess.open_encrypted_with_pass(g.SAVE_PATH, FileAccess.READ, g.KEY)
		if save_file != null:
			check_button.hide()
			check_button_text.hide()
			continue_panel.show()

func _on_continue_button_pressed() -> void:
	if g.load_game():
		if g.level%10 == 0 and g.level < 50:
			change_scene.emit("shop_scene", "bubble_transition")
		else:
			change_scene.emit("level_scene", "bubble_transition")
	else:
		error_text.show()
		_ready()

func _on_start_button_pressed() -> void:
	g.reinitialize()
	g.tutorial = check_button.button_pressed
	change_scene.emit("level_scene", "bubble_transition")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
