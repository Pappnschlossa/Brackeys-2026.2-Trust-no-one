extends Control

signal change_scene
signal add_scene_as_an_overlay
signal shake_screen

@export var A : Control
@export var B : Control
@export var C : Control
@export var D : Control
@export var E : Control
@export var F : Control
@onready var number_nodes : Array[Control] = [A, B, C, D, E, F]
@export var left_ui : Control
@export var question : Control
@export var door0 : Control
@export var door1 : Control
@onready var doors : Array[Control] = [door0, door1]
@export var numbers_container : GridContainer
@export var fake_transition_rect : ColorRect
@export var envelope_overlay : Control
@export var warning : Control
@export var tutorial_scene : Control
@export var backgrounds_20 : Node2D
@export var backgrounds_40 : Node2D
@export var backgrounds_50 : Node2D

const TRUE_NUMBERS : Array[int] = [0, 2, 3, 4, 5, 6, 7, 8, 9]
const TRUE_ODD_NUMBERS : Array[int] = [3, 5, 7, 9]

const OPERATOR_TO_SIGN : Dictionary[String, String] = {
	"plus" : "+",
	"minus" : "-",
	"mult" : "x"
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

const FORMAT_PARITY_SELF : Dictionary[int, String] = {
	-2 : "even number",
	-1 : "an odd number",
	0 : "the number 0",
	1 : "the number 1",
	2 : "the number 2",
	3 : "the number 3",
	4 : "the number 4",
	5 : "the number 5",
	6 : "the number 6",
	7 : "the number 7",
	8 : "the number 8",
	9 : "the number 9"
}

var TRUE_DOOR_ID : int
var FALSE_DOOR_ID : int
var numbers : Array[Number]
var AMOUNT : int # Amount of numbers
var MAX_ID : int
var QUESTION : int # ID of number
var TRUE_ANSWER : int # Value of number
var FALSE_ANSWER : int # False value of number
var ANSWER_50 : String

var active_numpad : int = -1
var number_guesses : Array[int]
var using_envelope : bool = false

func _ready() -> void:
	if g.level <= 20:
		backgrounds_20.show()
		backgrounds_40.hide()
		backgrounds_50.hide()
	elif g.level <= 40:
		backgrounds_20.hide()
		backgrounds_40.show()
		backgrounds_50.hide()
	else:
		backgrounds_20.hide()
		backgrounds_40.hide()
		backgrounds_50.show()
		$Shadow40.show()
	if g.level < g.tutorial_level_threshold:
		initialize_level_variables(true)
		generate_tutorial_text()
	elif g.level == 50:
		generate_level_50()
	else:
		initialize_level_variables(false)
		generate_text()
	update_nodes()
	numbers_container.add_numpad.connect(_on_add_numpad)
	if g.level == 50:
		g.current_items = ["EMPTY", "EMPTY", "EMPTY", "EMPTY"]
	left_ui._on_inventory_reload()
	item_tutorial()
	left_ui.entered_level()
	if g.level == 1 and g.tutorial:
		tutorial_scene.show()
	if g.level == 3 and g.tutorial:
		tutorial_scene.part_two()
		tutorial_scene.show()

func item_tutorial() -> void:
	if g.level == 3 or g.level == 6:
		left_ui._on_item_bought("MAGNIFYING_GLASS")
	if g.level == 50:
		left_ui._on_item_bought("ENVELOPE")

func _on_add_numpad(numpad_id: int) -> void:
	var pos = number_nodes[numpad_id].global_position + number_nodes[numpad_id].size/2
	add_scene_as_an_overlay.emit("numpad_overlay", pos)
	active_numpad = numpad_id

func _on_numpad_button_pressed(n: int) -> void:
	# Update the visuals to see which is selected
	number_guesses[active_numpad] = n
	var number_guess : MarginContainer = number_nodes[active_numpad].get_node("%NumberGuess")
	number_guess.number = n
	number_guess.update_number()
	number_guess.update_opacity(1) # USELESS FOR NOW (SHADER)

func generate_tutorial_text() -> void:
	var numbers_in_use : Array[int] = g.get_array_of_numbers_in_use_without_multiplicity()
	numbers_in_use.erase(1)
	var other_number : int = numbers_in_use[0]
	var id = 0
	for N in numbers:
		N.clue.is_equation = false
		match g.level:
			1:
				if N.val == 1:
					N.clue.target = id
					if other_number == 0:
						N.clue.value = [2, 3, 4, 5, 6, 7, 8, 9].pick_random() # To avoid saying the truth about being 1
					else:
						N.clue.value = (other_number+1) % 10
				else:
					N.clue.target = abs(id-1)
					N.clue.value = 1
			2:
				if N.val == 1:
					N.clue.target = id
					N.clue.value = -2
				else:
					N.clue.target = id
					N.clue.value = -1
			3:
				if N.val == 1:
					N.clue.target = abs(id-1)
					N.clue.value = 1
				else:
					N.clue.target = abs(id-1)
					N.clue.value = 1
		id += 1

func initialize_level_variables(odd : bool = false) -> void:
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
	var id_of_1 : int = randi_range(0, MAX_ID)
	numbers[id_of_1].val = 1
	possible_ids.erase(id_of_1)
	for id in possible_ids:
		if odd:
			numbers[id].val = TRUE_ODD_NUMBERS.pick_random()
		else:
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
				for node in number_nodes:
					node.is_not_question()
				number_nodes[n].is_question()
		n += 1

func generate_text(envelope_id = null) -> void:
	var id = 0
	
	for N in numbers:
		if envelope_id != null and id != envelope_id:
			id += 1
			continue

		var possible_types : Array[bool] = [true, false]
		if can_be_equation(id) or (N.val == 1 and AMOUNT >= 3):
			N.clue.is_equation = possible_types.pick_random()
		else:
			N.clue.is_equation = false
		if !N.clue.is_equation:
			var possible_targets : Array[int] = g.possible_targets(id)
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
						if g.level < 30:
							N.clue.value = randi_range(0, 9)
							if N.clue.value >= old_value:
								N.clue.value = (N.clue.value + 1) % 10
						else: # Only use numbers that are in present
							var possible_numbers : Array[int] = g.get_array_of_numbers_in_use_without_multiplicity()
							possible_numbers.erase(old_value)
							N.clue.value = possible_numbers.pick_random()
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
				N.clue.equation_targets.sort()
				N.clue.operator = ["plus", "minus", "mult"].pick_random()
				if N.clue.operator == "minus":
					if randf() < 0.5: # if substraction then 1/2 chances to swap
						N.clue.equation_targets.reverse()
					if numbers[N.clue.equation_targets[0]].val - numbers[N.clue.equation_targets[1]].val == 1:
						# Checks if equation remains false
						# (mult or plus are always false with 1 imposter and no multiple occurence of the same number in the equation so we only check minus)
						N.clue.equation_targets.reverse()
		id += 1

func generate_level_50() -> void:
	TRUE_DOOR_ID = randi_range(0, 1)
	FALSE_DOOR_ID = abs(TRUE_DOOR_ID - 1)
	if TRUE_DOOR_ID == 0:
		ANSWER_50 = "right"
	else:
		ANSWER_50 = "left"
	AMOUNT = 1
	MAX_ID = AMOUNT - 1
	number_guesses.resize(AMOUNT)
	number_guesses.fill(-1)
	var N : Number = Number.new()
	N.clue = Clue.new()
	numbers.append(N)
	numbers[0].val = 1
	for n in g.number_occurences:
		g.number_occurences[n] = 0
	g.number_occurences[1] = 1
	# Check if this still works with items
	#(update the enveloppe to always trigger without having to push a button)
	# Die does the same effect
	# Key does something
	QUESTION = -1
	N.clue.is_text = true
	N.clue.text = "There is no way for you to pick the correct door"

func update_nodes(envelope_id = null) -> void:
	for i in range(len(number_nodes)):
		if i <= MAX_ID:
			if envelope_id != null and envelope_id != i:
				continue
			#number_nodes[i].get_node("VBoxContainer/Text").text = str(numbers[i].val)
			var N = numbers[i]
			var text_line : String
			if !N.clue.is_text:
				if !N.clue.is_equation:
					if N.clue.target == i: # Target is self
						text_line = "I am\n%s" % FORMAT_PARITY_SELF[N.clue.value]
					else:
						text_line = "The number %s is %s" % [g.direction_of_number(i, N.clue.target), FORMAT_PARITY[N.clue.value]]
				else:
					text_line = "I'm equal to\n%s %s %s" % [g.ID_TO_LETTER[N.clue.equation_targets[0]], OPERATOR_TO_SIGN[N.clue.operator], g.ID_TO_LETTER[N.clue.equation_targets[1]]]
			else:
				text_line = N.clue.text
				number_nodes[0].get_node("%Text").add_theme_font_size_override("normal_font_size", 28)
			number_nodes[i].get_node("%Text").text = text_line
			number_nodes[i].visible = true
		else:
			number_nodes[i].visible = false
	if envelope_id != null:
		return
	left_ui.update_hidden_numbers()
	if g.level < 50:
		question.get_node("Text").text = "Which number is in cage %s?" % g.ID_TO_LETTER[QUESTION]
		if TRUE_DOOR_ID == 0:
			door0.get_node("SignTexture/Text").text = str(TRUE_ANSWER)
			door1.get_node("SignTexture/Text").text = str(FALSE_ANSWER)
		else:
			door0.get_node("SignTexture/Text").text = str(FALSE_ANSWER)
			door1.get_node("SignTexture/Text").text = str(TRUE_ANSWER)
	else:
		question.get_node("Text").text = "Which is the correct door?"
		door0.get_node("SignTexture/Text").text = "?"
		door1.get_node("SignTexture/Text").text = "?"

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
	if g.level != 50 and number_guesses[QUESTION] == -1:
		guess_needed_warning()
		return
	if g.level == 50 and g.current_items[0] == "ENVELOPE":
		envelope_needed_warning()
		return
	get_node("FootstepsSFX").play()
	if TRUE_DOOR_ID == 0:	transition_to_next_level()
	else:	wrong_door(0)

func _on_door_1_button_pressed() -> void:
	if g.level != 50 and number_guesses[QUESTION] == -1:
		guess_needed_warning()
		return
	if g.level == 50 and g.current_items[0] == "ENVELOPE":
		envelope_needed_warning()
		return
	get_node("FootstepsSFX").play()
	if TRUE_DOOR_ID == 1:	transition_to_next_level()
	else:	wrong_door(1)

func wrong_door(door_id : int) -> void:
	await fake_transition_rect.fake_transition()
	left_ui.update_health()
	if g.lives == 0:
		lose()
	doors[door_id].get_node("DoorEyes").visible = true

func lose() -> void:
	# Show every number without cage
	for i in range(len(numbers)):
		number_nodes[i].get_node("%NumberGuess").modulate.a = 0.6
		number_nodes[i].get_node("%TrueNumber").number = numbers[i].val
		number_nodes[i].get_node("%TrueNumber").update_number()
		number_nodes[i].get_node("%TrueNumber").show()
	add_scene_as_an_overlay.emit("lose_scene")

func guess_needed_warning() -> void:
	warning.show()

func envelope_needed_warning() -> void:
	warning.get_node("DialogBox").size.y -= 250
	warning.get_node("DialogBox/Wait").text = "Are you sure?"
	var additional_text : String = ""
	if g.envelope_in_level_use_amount <= 2:
		warning.get_node("DialogBox").size.y += 100
		additional_text = "\n\nThe envelope in your items forces the selected number to say something else."
	warning.get_node("DialogBox/Text").text = "\n\n\nYou collected an item on your path you might need to use.%s" % additional_text
	warning.show()

func transition_to_next_level() -> void:
	g.level += 1
	var has_correct_guesses : bool = false
	for id in range(len(number_guesses)):
		if numbers[id].val == number_guesses[id]:
			number_nodes[id].collect_coin(Vector2(146.0, 1040.0))
			await get_tree().create_timer(0.7).timeout
			has_correct_guesses = true
	if has_correct_guesses:
		await get_tree().create_timer(1.1).timeout
	if g.level == 51:
		change_scene.emit("win_scene", "bubble_transition")
	elif g.level%10 == 0 and g.level != 50:
		change_scene.emit("shop_scene", "bubble_transition")
	else:
		change_scene.emit("level_scene", "bubble_transition")

func use_item(item_id : String) -> void:
	match item_id:
		"DICE":
			await get_tree().create_timer(0.6).timeout
			shake_screen.emit()
			await get_tree().create_timer(0.1).timeout
			change_scene.emit("level_scene")
		"ENVELOPE":
			var target_modulate = envelope_overlay.modulate
			target_modulate.a = 1.0
			envelope_overlay.modulate.a = 0.0
			envelope_overlay.show()
			var tween = create_tween()
			tween.tween_property(
				envelope_overlay,
				"modulate",
				target_modulate,
				0.3
			)
			using_envelope = true
			g.envelope_in_level_use_amount += 1
		"KEY":
			await get_tree().create_timer(0.6).timeout
			transition_to_next_level()
		"LIFE_POTION":
			pass
		"MAGNIFYING_GLASS":
			for id in range(len(numbers)):
				if numbers[id].val == 1:
					number_nodes[id].reveal_one_with_magnifying_glass()
					number_guesses[id] = 1
					break

func _on_warning_button_pressed() -> void:
	warning.get_node("DialogBox").size = Vector2(788.0, 563.75)
	warning.hide()
