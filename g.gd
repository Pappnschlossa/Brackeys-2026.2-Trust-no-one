extends Node

var level : int = 1
func amount_of_numbers():
	if level <= 5:
		return 3
	elif level <= 10:
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

func reinitialize():
	level = 1
	lives = 3
