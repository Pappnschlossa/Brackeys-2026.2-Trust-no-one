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

func _ready() -> void:
	initialize_level_variables()
	generate_text()
	update_nodes()

func initialize_level_variables() -> void:
	TRUE_DOOR_ID = randi_range(0, 1)
	FALSE_DOOR_ID = abs(TRUE_DOOR_ID - 1)
	AMOUNT = g.amount_of_numbers()
	MAX_ID = AMOUNT - 1
	var possible_ids : Array[int]
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

func generate_text() -> void:
	var id = 0
	for N in numbers:
		var possible_types : Array[bool] = [true, false]
		if N.val != 1:
			if can_be_equation(id):
				N.clue.is_equation = possible_types.pick_random()
			else:
				N.clue.is_equation = false
			if !N.clue.is_equation:
				var possible_targets : Array[int] = [max(0, id-1), id, min(id+1, MAX_ID)]
				N.clue.target = possible_targets.pick_random()
				if randi_range(0, 1) == 1: # 1 in 2 chances to show parity:
					if numbers[N.clue.target].val % 2 == 0: # Even
						N.clue.value = -2
					else: # Odd
						N.clue.value = -1
				else: # Directly announce the number
					N.clue.value = numbers[N.clue.target].val
				print("%s says %s is %s" % [ID_TO_LETTER[id], ID_TO_LETTER[N.clue.target], FORMAT_PARITY[N.clue.value]])
			else: # N.clue.is_equation:
				var possible_equations : Array[Array] = find_equations(id)
				var equation = possible_equations.pick_random()
				N.clue.equation_targets = [equation[0], equation[1]]
				N.clue.operator = equation[2]
				print("%s says %s %s %s = %s" % [ID_TO_LETTER[id], ID_TO_LETTER[N.clue.equation_targets[0]], OPERATOR_TO_SIGN[N.clue.operator], ID_TO_LETTER[N.clue.equation_targets[1]], ID_TO_LETTER[id]])
		id += 1

func update_nodes() -> void:
	for i in range(len(number_nodes)):
		if i <= MAX_ID:
			number_nodes[i].get_node("VBoxContainer/Text").text = str(numbers[i].val)
			number_nodes[i].visible = true
		else:
			number_nodes[i].visible = false

func can_be_equation(id) -> bool:
	for i in range(AMOUNT-1):
		for j in range(i+1, AMOUNT):
			if numbers[i].val + numbers[j].val == numbers[id].val:
				return true
			elif numbers[i].val - numbers[j].val == numbers[id].val or numbers[j].val - numbers[i].val == numbers[id].val:
				return true
			elif numbers[i].val * numbers[j].val == numbers[id].val:
				return true
	return false

func find_equations(id) -> Array[Array]:
	var equations : Array[Array] = []
	for i in range(AMOUNT-1):
		for j in range(i+1, AMOUNT):
			if numbers[i].val + numbers[j].val == numbers[id].val:
				equations.append([i, j, "plus"])
			if numbers[i].val - numbers[j].val == numbers[id].val:
				equations.append([i, j, "minus"])
			if numbers[j].val - numbers[i].val == numbers[id].val:
				equations.append([j, i, "minus"])
			if numbers[i].val * numbers[j].val == numbers[id].val:
				equations.append([i, j, "mult"])
	return equations

func _on_door_1_button_pressed() -> void:
	pass # Replace with function body.


func _on_door_2_button_pressed() -> void:
	pass # Replace with function body.
