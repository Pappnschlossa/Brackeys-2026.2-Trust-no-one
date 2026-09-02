extends AudioStreamPlayer

var musics : Array[AudioStream] = [
	preload("uid://b66lefg36xf2w"),
	preload("uid://bqfo03r2nanng"),
	preload("uid://c6alsmsn5x7kf"),
	preload("uid://bmfqi1vx0svs")
	]
var music_int : Array[int] = [0, 1, 2, 3]

func _ready() -> void:
	finished.connect(_on_music_finished)
	stream = musics[0]
	play()

func _on_music_finished() -> void:
	var next_index : int = 2 + randi_range(0, 1)
	var value : int = music_int.pop_at(next_index)
	music_int.push_front(value)
	stream = musics[value]
	play()

func reset() -> void:
	stop()
	music_int = [0, 1, 2, 3]
	stream = musics[0]
	play()

func new_game() -> void:
	stop()
	_on_music_finished()
