extends Control

signal cage_button_pressed

@export var coin : AnimatedSprite2D
@export var left_ui : Control

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

func is_question() -> void:
	get_node("%Texture").texture = load("uid://500jfuen1gng")
	get_node("%Lock").texture = load("uid://buhqjk78imbmr")

func is_not_question() -> void:
	get_node("%Texture").texture = load("uid://c51b1cgdr8rlk")
	get_node("%Lock").texture = load("uid://dmkaut56mi1t3")

func collect_coin(to : Vector2, wait_duration : float, move_duration : float) -> void:
	coin.global_position = global_position + size/2 + Vector2(0, 30)
	coin.play("coin_spin")
	coin.show()
	await get_tree().create_timer(wait_duration).timeout
	var tween = create_tween()
	tween.tween_property(
		coin,
		"global_position",
		to,
		move_duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	coin.get_node("SFX").play()
	g.money += 1
	g.total_coins_collected += 1
	left_ui.update_money()
	coin.hide()
