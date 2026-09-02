extends Control

signal item_effect

var item_id : String = "EQUAL"
var old_y : int
var item_pos : int
var used : bool = false
var just_bought : bool = false

func _ready() -> void:
	var mat = $Texture.material
	$Texture.material = mat.duplicate()
	$Texture.texture = g.ORBS[item_id].texture
	old_y = position.y
	if just_bought:
		position.y = -1080
		spawn_orb()

func spawn_orb() -> void:
	var tween = create_tween()
	tween.tween_property(
		self,
		"position",
		Vector2(position.x, old_y),
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
