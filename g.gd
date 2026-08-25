extends Node

var level : int = 1
const tutorial_level_threshold : int = 4
func amount_of_numbers() -> int:
	if level < tutorial_level_threshold:
		return 2
	if level < 10:
		return 3
	elif level < 20:
		return 4
	else:
		return 6

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

const DIRECTIONS : Dictionary[int, String] = {
	0 : "above me",
	1 : "to my upper right",
	2 : "to my right",
	3 : "to my lower right",
	4 : "below me",
	5 : "to my lower left",
	6 : "to my left",
	7 : "to my upper left"
}

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

func reinitialize():
	level = 1
	lives = 3
