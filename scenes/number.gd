extends MarginContainer

@export var number : int = 8
@export var is_in_cage : bool = false
var average_eyes_position : Vector2
var time_since_last_change : float = 0
var opacity_change : bool = false
var max_opacity : float
var min_opacity : float
var period : float = 3
var opacity_time : float = 0

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
	if is_in_cage:
		$Texture.modulate.a = 0
	average_eyes_position = $Eyes.position

func _process(delta: float) -> void:
	time_since_last_change += delta
	opacity_time += delta
	if time_since_last_change > 0.1:
		time_since_last_change = 0
		$Eyes.position = average_eyes_position + Vector2(randf_range(-1.5, 1), randf_range(-1.5, 1))
	if opacity_change:
		var a : float = TAU*opacity_time/period
		if a > TAU:
			a -= TAU
		$Texture.modulate.a = (max_opacity-min_opacity)*(sin(a)+1)/2 + min_opacity

func update_number() -> void:
	$Texture.texture = load(NUMBER_TO_TEXTURE[number])

func update_opacity(amount : float) -> void:
	max_opacity = amount
	min_opacity = max_opacity*3/5
	opacity_change = true
