extends Control

@export var number : int = 8

const NUMBER_TO_TEXTURE : Dictionary[int, String] = {
	0 : "uid://bbqnr5imwtssa",
	1 : "uid://ck6rj4cx3lnum",
	2 : "uid://dl38a33retswa",
	3 : "uid://scahwf1ngurj",
	4 : "uid://cka50jebq5nc1",
	5 : "uid://iobuenb5vc7c",
	6 : "uid://bcm1q3gbu86bj",
	7 : "uid://7po5suu46rs",
	8 : "uid://d3dnqlpyqhkmh",
	9 : "uid://fmw3vnuognqa"
}

func _ready() -> void:
	update_number()

func update_number() -> void:
	$Texture.texture = load(NUMBER_TO_TEXTURE[number])
