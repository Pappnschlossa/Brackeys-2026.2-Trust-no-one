extends GridContainer

signal add_numpad

@export var A : Control
@export var B: Control
@export var C : Control
@export var D : Control
@export var E : Control
@export var F : Control
@onready var number_cages : Array[Control] = [A, B, C, D, E, F]


func _ready() -> void:
	var amount_of_numbers : int = g.amount_of_numbers()
	if amount_of_numbers == 3 or amount_of_numbers == 6:
		columns = 3
	else: # amount_of_numbers == 2 or amount_of_numbers == 4
		columns = 2
	for i in range(len(number_cages)):
		number_cages[i].cage_button_pressed.connect(_on_cage_button_pressed.bind(i))

func _on_cage_button_pressed(numpad_id : int) -> void:
	add_numpad.emit(numpad_id)
