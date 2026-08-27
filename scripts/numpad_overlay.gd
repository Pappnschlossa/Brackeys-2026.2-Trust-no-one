extends Control

signal change_scene
signal add_scene_as_an_overlay
signal numpad_button_pressed
signal remove_overlay

@export var button_0 : MarginContainer
@export var button_1 : MarginContainer
@export var button_2 : MarginContainer
@export var button_3 : MarginContainer
@export var button_4 : MarginContainer
@export var button_5 : MarginContainer
@export var button_6 : MarginContainer
@export var button_7 : MarginContainer
@export var button_8 : MarginContainer
@export var button_9 : MarginContainer
@onready var buttons : Array[MarginContainer] = [button_0, button_1, button_2, button_3, button_4, button_5, button_6, button_7, button_8, button_9]

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
