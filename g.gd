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

func reinitialize():
	level = 1
	for n in g.number_occurences:
		g.number_occurences[n] = 0
