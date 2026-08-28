extends GridContainer

signal add_numpad

@export var A : Control
@export var B: Control
@export var C : Control
@export var D : Control
@export var E : Control
@export var F : Control
@onready var number_cages : Array[Control] = [A, B, C, D, E, F]
@export var level : Control


func _ready() -> void:
	var amount_of_numbers : int = g.amount_of_numbers()
	if amount_of_numbers == 3 or amount_of_numbers == 6:
		columns = 3
	else: # amount_of_numbers == 2 or amount_of_numbers == 4
		columns = 2
	for i in range(len(number_cages)):
		number_cages[i].cage_button_pressed.connect(_on_cage_button_pressed.bind(i))

func _on_cage_button_pressed(numpad_id : int) -> void:
	if level.using_envelope:
		var old_text : String = level.number_nodes[numpad_id].get_node("%Text").text
		var new_text : String = old_text
		while old_text == new_text:
			level.generate_text(numpad_id)
			level.update_nodes(numpad_id)
			new_text = level.number_nodes[numpad_id].get_node("%Text").text
		level.using_envelope = false
		var target_modulate = level.envelope_overlay.modulate
		target_modulate.a = 0.0
		level.envelope_overlay.modulate.a = 1.0
		level.envelope_overlay.show()
		var tween = create_tween()
		tween.tween_property(
			level.envelope_overlay,
			"modulate",
			target_modulate,
			0.3
		)
		await tween.finished
		level.envelope_overlay.visible = false
	else:
		add_numpad.emit(numpad_id)
