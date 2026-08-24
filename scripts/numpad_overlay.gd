extends Control

signal change_scene
signal add_scene_as_an_overlay
signal numpad_button_pressed
signal remove_overlay

@export var button_0 : Button
@export var button_1 : Button
@export var button_2 : Button
@export var button_3 : Button
@export var button_4 : Button
@export var button_5 : Button
@export var button_6 : Button
@export var button_7 : Button
@export var button_8 : Button
@export var button_9 : Button
@onready var buttons : Array[Button] = [button_0, button_1, button_2, button_3, button_4, button_5, button_6, button_7, button_8, button_9]

func _ready() -> void:
	update_buttons_visibility()

func update_buttons_visibility() -> void:
	for n in g.number_occurences:
		if g.number_occurences[n] >= 1:
			buttons[n].visible = true
		else:
			buttons[n].visible = false

func _on_button_pressed(n: int) -> void:
	numpad_button_pressed.emit(n)
	remove_overlay.emit()
