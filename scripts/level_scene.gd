extends Control

signal change_scene
signal add_scene_as_an_overlay

@export var A : Control
@export var B : Control
@export var C : Control
@export var D : Control
@export var E : Control
@export var F : Control
@onready var number_nodes : Array[Control] = [A, B, C, D, E, F]
@export var question : Control
@export var info : Control
@export var door0 : Control
@export var door1 : Control
@export var numbers_container : GridContainer

const TRUE_NUMBERS = [0, 2, 3, 4, 5, 6, 7, 8, 9]
const ID_TO_LETTER : Dictionary[int, String] = {
	0 : "A",
	1 : "B",
	2 : "C",
	3 : "D",
	4 : "E",
	5 : "F"
}

const OPERATOR_TO_SIGN : Dictionary[String, String] = {
	"plus" : "+",
	"minus" : "-",
	"mult" : "*"
}

const FORMAT_PARITY : Dictionary[int, String] = {
	-2 : "even",
	-1 : "odd",
	0 : "0",
	1 : "1",
	2 : "2",
	3 : "3",
	4 : "4",
	5 : "5",
	6 : "6",
	7 : "7",
	8 : "8",
	9 : "9"
}

var TRUE_DOOR_ID : int
var FALSE_DOOR_ID : int
var numbers : Array[Number]
var AMOUNT : int # Amount of numbers
var MAX_ID : int
var QUESTION : int # ID of number
var TRUE_ANSWER : int # Value of number
var FALSE_ANSWER : int # False value of number

var active_numpad : int = -1
var number_guesses : Array[int]

func _ready() -> void:
	initialize_level_variables()
	generate_text()
	update_nodes()
	numbers_container.add_numpad.connect(_on_add_numpad)

func _on_add_numpad(numpad_id: int) -> void:
	var pos = Vector2(numpad_id*400 + 300, 1080/2)
	add_scene_as_an_overlay.emit("numpad_overlay", pos)
	active_numpad = numpad_id

func _on_numpad_button_pressed(n: int) -> void:
	# Update the visuals to see which is selected
	number_guesses[active_numpad] = n # STOPPED HERE FOR TODAY

func initialize_level_variables() -> void:
	TRUE_DOOR_ID = randi_range(0, 1)
	FALSE_DOOR_ID = abs(TRUE_DOOR_ID - 1)
	AMOUNT = g.amount_of_numbers()
	MAX_ID = AMOUNT - 1
	var possible_ids : Array[int]
	number_guesses.resize(AMOUNT)
	number_guesses.fill(-1)
	for i in range(AMOUNT):
		var N : Number = Number.new()
		N.clue = Clue.new()
		numbers.append(N)
		possible_ids.append(i)
	var id_of_minus_1 : int = randi_range(0, MAX_ID)
	numbers[id_of_minus_1].val = 1
	possible_ids.erase(id_of_minus_1)
	for id in possible_ids:
		numbers[id].val = TRUE_NUMBERS.pick_random()
	for n in g.number_occurences:
		g.number_occurences[n] = 0
	for N in numbers:
		g.number_occurences[N.val] += 1
	# Choose question
	var numbers_in_use : Array[int] = g.get_array_of_numbers_in_use_without_multiplicity()
	TRUE_ANSWER = numbers_in_use.pick_random()
	numbers_in_use.erase(TRUE_ANSWER)
	FALSE_ANSWER = numbers_in_use.pick_random()
	# Pick random number that is equal to this number:
	var random_number_equal_to_answer : int = randi_range(0, g.number_occurences[TRUE_ANSWER]-1)
	var n : int = 0
	for N in numbers:
		if N.val == TRUE_ANSWER:
			if random_number_equal_to_answer >= 1:
				random_number_equal_to_answer -= 1
			else:
				QUESTION = n
		n += 1

func generate_text() -> void:
	var id = 0
	for N in numbers:
		var possible_types : Array[bool] = [true, false]
		if can_be_equation(id) or N.val == 1:
			N.clue.is_equation = possible_types.pick_random()
		else:
			N.clue.is_equation = false
		if !N.clue.is_equation:
			var possible_targets : Array[int] = [max(0, id-1), id, min(id+1, MAX_ID)]
			N.clue.target = possible_targets.pick_random()
			if randf() < 0.2: # chances to show parity:
				if numbers[N.clue.target].val % 2 == 0: # Even
					N.clue.value = -2
				else: # Odd
					N.clue.value = -1
			else: # Directly announce the number
				N.clue.value = numbers[N.clue.target].val
			if N.val == 1: # Turn clue into a lie if number is 1
				var old_value : int = N.clue.value
				match N.clue.value:
					-2: N.clue.value = -1
					-1: N.clue.value = -2
					_:
						N.clue.value = randi_range(0, 9)
						if N.clue.value >= old_value:
							N.clue.value = (N.clue.value + 1) % 10
		else: # N.clue.is_equation:
			if N.val != 1:
				var possible_equations : Array[Array] = find_equations(id)
				var equation : Array = possible_equations.pick_random()
				N.clue.equation_targets = [equation[0], equation[1]]
				N.clue.operator = equation[2]
			else: # N.val == 1: # Turn clue into a lie if number is 1
				var possible_targets : Array = Array(range(AMOUNT))
				possible_targets.erase(id)
				var first_member : int = possible_targets.pick_random()
				possible_targets.erase(first_member)
				var second_member : int = possible_targets.pick_random()
				N.clue.equation_targets = [first_member, second_member]
				N.clue.operator = ["plus", "minus", "mult"].pick_random()
				if N.clue.operator == "minus":
					if randf() < 0.5: # if substraction then 1/2 chances to swap
						N.clue.equation_targets.reverse()
					if numbers[N.clue.equation_targets[0]].val - numbers[N.clue.equation_targets[1]].val == 1:
						# Checks if equation remains false
						# (mult or plus are always false with 1 imposter and no multiple occurence of the same number in the equation so we only check minus)
						N.clue.equation_targets.reverse()
		id += 1


func update_nodes() -> void:
	for i in range(len(number_nodes)):
		if i <= MAX_ID:
			#number_nodes[i].get_node("VBoxContainer/Text").text = str(numbers[i].val)
			var N = numbers[i]
			if !N.clue.is_equation:
				number_nodes[i].get_node("VBoxContainer/Text").text = "%s says %s is %s" % [ID_TO_LETTER[i], ID_TO_LETTER[N.clue.target], FORMAT_PARITY[N.clue.value]]
			else:
				number_nodes[i].get_node("VBoxContainer/Text").text = "%s says %s %s %s = %s" % [ID_TO_LETTER[i], ID_TO_LETTER[N.clue.equation_targets[0]], OPERATOR_TO_SIGN[N.clue.operator], ID_TO_LETTER[N.clue.equation_targets[1]], ID_TO_LETTER[i]]
			number_nodes[i].visible = true
		else:
			number_nodes[i].visible = false
	info.get_node("Text").text = str(g.number_occurences)
	question.get_node("Text").text = "What number is %s?" % ID_TO_LETTER[QUESTION]
	if TRUE_DOOR_ID == 0:
		door0.get_node("Text").text = str(TRUE_ANSWER)
		door1.get_node("Text").text = str(FALSE_ANSWER)
	else:
		door0.get_node("Text").text = str(FALSE_ANSWER)
		door1.get_node("Text").text = str(TRUE_ANSWER)

func can_be_equation(id) -> bool:
	for i in range(AMOUNT-1):
		if i == id: continue
		for j in range(i+1, AMOUNT):
			if j == id: continue
			elif numbers[i].val + numbers[j].val == numbers[id].val:
				return true
			elif numbers[i].val - numbers[j].val == numbers[id].val or numbers[j].val - numbers[i].val == numbers[id].val:
				return true
			elif numbers[i].val * numbers[j].val == numbers[id].val:
				return true
	return false

func find_equations(id) -> Array[Array]:
	var equations : Array[Array] = []
	for i in range(AMOUNT-1):
		if i == id: continue
		for j in range(i+1, AMOUNT):
			if j == id: continue
			if numbers[i].val + numbers[j].val == numbers[id].val:
				equations.append([i, j, "plus"])
			if numbers[i].val - numbers[j].val == numbers[id].val:
				equations.append([i, j, "minus"])
			if numbers[j].val - numbers[i].val == numbers[id].val:
				equations.append([j, i, "minus"])
			if numbers[i].val * numbers[j].val == numbers[id].val:
				equations.append([i, j, "mult"])
	return equations

func _on_door_0_button_pressed() -> void:
	if TRUE_DOOR_ID == 0:	transition_to_next_level()
	else:	wrong_door(0)

func _on_door_1_button_pressed() -> void:
	if TRUE_DOOR_ID == 1:	transition_to_next_level()
	else:	wrong_door(1)

func wrong_door(door_id : int) -> void:
	g.lives -= 1

func transition_to_next_level() -> void:
	g.level += 1
	change_scene.emit("level_scene", )
