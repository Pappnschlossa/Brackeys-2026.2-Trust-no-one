extends Node

var level_rng = RandomNumberGenerator.new()
var shop_rng = RandomNumberGenerator.new()
const languages : Array[String] = ["en", "fr"]
var current_language_id : int = 0
const SAVE_PATH = "user://savefile.save"
const KEY : String = "I don't know what to use for a password"

func _ready() -> void:
	var master_seed : int = randi()
	level_rng.seed = master_seed
	shop_rng.seed = master_seed
	old_level_rng_state = level_rng.state
	old_shop_rng_state = shop_rng.state
	update_directions_language()

func update_language() -> void:
	var preferred_language = OS.get_locale_language()
	for i in range(len(languages)):
		if preferred_language == languages[i]:
			TranslationServer.set_locale(preferred_language)
			current_language_id = i
		else:
			TranslationServer.set_locale("en")
			current_language_id = 0


func update_directions_language() -> void:
	DIRECTIONS = {
		0 : tr("above me"),
		1 : tr("to my upper right"),
		2 : tr("to my right"),
		3 : tr("to my lower right"),
		4 : tr("below me"),
		5 : tr("to my lower left"),
		6 : tr("to my left"),
		7 : tr("to my upper left")
	}

var level : int = 1
const tutorial_level_threshold : int = 4
func amount_of_numbers() -> int:
	if level < tutorial_level_threshold:
		return 2
	if level < 10:
		return 3
	elif level < 20:
		return 4
	elif level < 50:
		return 6
	else:
		return 1

var number_occurences : Dictionary[int, int] = {
	0 : 0,
	1 : 0,
	2 : 0,
	3 : 0,
	4 : 0,
	5 : 0,
	6 : 0,
	7 : 0,
	8 : 0,
	9 : 0
}

func get_array_of_numbers_in_use_without_multiplicity() -> Array[int]:
	var numbers_in_use : Array[int] = []
	for n in number_occurences:
		if number_occurences[n] >= 1:
			numbers_in_use.append(n)
	return numbers_in_use

var lives : int = 3
var max_lives : int = 3

func possible_targets(id : int) -> Array[int]:
	match amount_of_numbers():
		2:
			return [0, 1]
		3:
			return [max(0, id-1), id, min(id+1, 2)]
		4:
			return [0, 1, 2, 3]
		6:
			match id:
				0:
					return [0, 0, 0, 1, 3, 4]
				1:
					return [0, 1, 2, 3, 4, 5]
				2:
					return [1, 2, 2, 2, 4, 5]
				3:
					return [0, 1, 3, 3, 3, 4]
				4:
					return [0, 1, 2, 3, 4, 5]
				5:
					return [1, 2, 4, 5, 5, 5]
	return [-1]

var DIRECTIONS : Dictionary[int, String]

func direction_of_number(source_id : int, target_id : int) -> String:
	match amount_of_numbers():
		2:	match source_id:
			0:	return DIRECTIONS[2]
			1:	return DIRECTIONS[6]
		3:	match source_id:
			0:	return DIRECTIONS[2]
			1:	match target_id:
				0:	return DIRECTIONS[6]
				2:	return DIRECTIONS[2]
			2:	return DIRECTIONS[6]
		4:	match source_id:
			0:	match target_id:
				1:	return DIRECTIONS[2]
				2:	return DIRECTIONS[4]
				3:	return DIRECTIONS[3]
			1:	match target_id:
				0:	return DIRECTIONS[6]
				2:	return DIRECTIONS[5]
				3:	return DIRECTIONS[4]
			2:	match target_id:
				0:	return DIRECTIONS[0]
				1:	return DIRECTIONS[1]
				3:	return DIRECTIONS[2]
			3:	match target_id:
				0:	return DIRECTIONS[7]
				1:	return DIRECTIONS[0]
				2:	return DIRECTIONS[6]
		6:	match source_id:
			0:	match target_id:
				1:	return DIRECTIONS[2]
				3:	return DIRECTIONS[4]
				4:	return DIRECTIONS[3]
			1:	match target_id:
				0:	return DIRECTIONS[6]
				2:	return DIRECTIONS[2]
				3:	return DIRECTIONS[5]
				4:	return DIRECTIONS[4]
				5:	return DIRECTIONS[3]
			2:	match target_id:
				1:	return DIRECTIONS[6]
				4:	return DIRECTIONS[5]
				5:	return DIRECTIONS[4]
			3:	match target_id:
				0:	return DIRECTIONS[0]
				1:	return DIRECTIONS[1]
				4:	return DIRECTIONS[2]
			4:	match target_id:
				0:	return DIRECTIONS[7]
				1:	return DIRECTIONS[0]
				2:	return DIRECTIONS[1]
				3:	return DIRECTIONS[6]
				5:	return DIRECTIONS[2]
			5:	match target_id:
				1:	return DIRECTIONS[7]
				2:	return DIRECTIONS[0]
				4:	return DIRECTIONS[6]
	return ""

var money : int = 200

var ITEMS : Dictionary[String, Item] = {
	"DICE" : preload("res://ressource/dice.tres"),
	"ENVELOPE" : preload("res://ressource/envelope.tres"),
	"KEY" : preload("res://ressource/key.tres"),
	"LIFE_POTION" : preload("res://ressource/life_potion.tres"),
	"MAGNIFYING_GLASS" : preload("res://ressource/magnifying_glass.tres")
}

var current_items : Array[String] = ["EMPTY", "EMPTY", "EMPTY", "EMPTY"]

func get_nb_of_items() -> int:
	var count : int = 0
	for item in current_items:
		if item != "EMPTY":
			count += 1
	return count
const MAX_ITEM_AMOUNT = 4
var nb_of_items_being_bought : int = 0

func can_buy_item(price : int) -> bool:
	if money >= price and get_nb_of_items() < (MAX_ITEM_AMOUNT - nb_of_items_being_bought):
		return true
	return false

func can_buy_orb(price : int) -> bool:
	if money >= price and get_nb_of_orbs() < (2 - nb_of_orbs_being_bought):
		return true
	return false

func can_use_item(item_id : String) -> bool:
	if item_id == "DICE" and level == 40:
		return false
	return true

const ID_TO_LETTER : Dictionary[int, String] = {
	0 : "A",
	1 : "B",
	2 : "C",
	3 : "D",
	4 : "E",
	5 : "F"
}

var tutorial : bool = false

var envelope_in_level_use_amount : int = 0

var total_coins_collected : int = 0

var ORBS : Dictionary[String, Orb] = {
	"EQUAL" : preload("uid://bm4fysp5kfwb0"),
	"HEART" : preload("uid://bbgtksphsk3nb"),
	"QUESTIONMARK" : preload("uid://cdv27yxdcdobp"),
	"SUN" : preload("uid://bqg3cm4psd8m0")
	}

var current_orbs : Array[String] = ["EMPTY_ORB", "EMPTY_ORB"]

var nb_of_orbs_being_bought : int = 0

func get_nb_of_orbs() -> int:
	var count : int = 0
	for item in current_orbs:
		if item != "EMPTY_ORB":
			count += 1
	return count

var amount_of_tutorial_items_received : int = 0

var old_level_rng_state : int
var old_shop_rng_state : int

func save_game():
	var save_file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.WRITE, KEY)
	var save_dict = {
		"master_seed" : level_rng.seed,
		"level_rng_state" : level_rng,
		"shop_rng_state" : shop_rng,
		"level" : level,
		"lives" : lives,
		"money" : money,
		"envelope_in_level_use_amount" : envelope_in_level_use_amount,
		"total_coins_collected" : total_coins_collected,
		"nb_orbs_being_bought" : nb_of_items_being_bought,
		"nb_of_items_being_bought" : nb_of_items_being_bought,
		"max_lives" : max_lives,
		"amount_of_tutorial_items_received" : amount_of_tutorial_items_received,
		"current_orbs" : current_orbs,
		"current_items": current_items
	}
	old_level_rng_state = level_rng.state
	old_shop_rng_state = shop_rng.state
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save_dict)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)
	save_file.close()

func update_save(changed_items : Array[String], values : Array) -> void:
	var save_dict = {
		"master_seed" : level_rng.seed,
		"level_rng_state" : old_level_rng_state,
		"shop_rng_state" : old_shop_rng_state,
		"level" : level,
		"lives" : lives,
		"money" : money,
		"envelope_in_level_use_amount" : envelope_in_level_use_amount,
		"total_coins_collected" : total_coins_collected,
		"nb_orbs_being_bought" : nb_of_items_being_bought,
		"nb_of_items_being_bought" : nb_of_items_being_bought,
		"max_lives" : max_lives,
		"amount_of_tutorial_items_received" : amount_of_tutorial_items_received,
		"current_orbs" : current_orbs,
		"current_items": current_items
	}
	for i in range(len(changed_items)):
		save_dict[changed_items[i]] = values[i]
	var save_file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.WRITE, KEY)
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	save_file.close()

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var save_file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.READ, KEY)
	if save_file == null:
		print("Failed to open save file")
		return false
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		# Creates the helper class to interact with JSON.
		var json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		# Get the data from the JSON object.
		var data = json.data
		# Now we set the remaining variables.
		for i in data.keys():
			match i:
				"master_seed" :
					level_rng.set("seed", data[i])
					shop_rng.set("seed", data[i])
				"level_rng_state" :	level_rng.set("state", data[i])
				"shop_rng_state" :	shop_rng.set("state", data[i])
				"current_items" :
					var items : Array[String] = []
					for item in data[i]:
						items.append(item)
					current_items = items
				"current_orbs" :
					var orbs : Array[String] = []
					for orb in data[i]:
						orbs.append(orb)
					current_orbs = orbs
				_:	set(i, data[i])
	save_file.close()
	return true

func erase_save_file() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))

func reinitialize() -> void:
	level = 1
	lives = 3
	money = 0
	envelope_in_level_use_amount = 0
	total_coins_collected = 0
	nb_of_orbs_being_bought = 0
	nb_of_items_being_bought = 0
	max_lives = 3
	amount_of_tutorial_items_received = 0
	current_orbs = ["EMPTY_ORB", "EMPTY_ORB"]
	current_items = ["EMPTY", "EMPTY", "EMPTY", "EMPTY"]
