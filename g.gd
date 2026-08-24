extends Node

var level : int = 1
func amount_of_numbers():
	if level <= 5:
		return 3
	elif level <= 10:
		return 4
	else:
		return 6

func reinitialize():
	level = 1
