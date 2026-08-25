extends GridContainer

signal add_numpad


func _ready() -> void:
	var amount_of_numbers : int = g.amount_of_numbers()
	if amount_of_numbers == 3 or amount_of_numbers == 6:
		columns = 3
	else: # amount_of_numbers == 2 or amount_of_numbers == 4
		columns = 2

func _on_button_pressed(numpad_id: int) -> void:
	add_numpad.emit(numpad_id)
