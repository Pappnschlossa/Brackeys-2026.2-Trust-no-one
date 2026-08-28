extends Control

signal cage_button_pressed

func _ready() -> void:
	get_node("%Texture").material = get_node("%Texture").material.duplicate()
	get_node("%TextID").text = g.ID_TO_LETTER[get_index()]

func _on_button_pressed() -> void:
	cage_button_pressed.emit()

func reveal_one_with_magnifying_glass() -> void:
	var magnifying_glass : TextureRect = get_node("%MagnifyingGlass")
	if magnifying_glass.visible:
		return
	var old_position = magnifying_glass.position
	magnifying_glass.position.x -= 1920
	magnifying_glass.show()
	var duration : float = 2.0
	var tween = create_tween()
	tween.tween_property(
		magnifying_glass,
		"position",
		old_position,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(duration-0.15).timeout
	var number_guess : MarginContainer = get_node("%NumberGuess")
	number_guess.number = 1
	number_guess.update_number()
	number_guess.update_opacity(1)
