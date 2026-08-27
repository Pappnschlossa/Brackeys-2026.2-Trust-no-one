extends Control

signal cage_button_pressed

func _ready() -> void:
	get_node("%Texture").material = get_node("%Texture").material.duplicate()
	get_node("%TextID").text = g.ID_TO_LETTER[get_index()]

func _on_button_pressed() -> void:
	cage_button_pressed.emit()
