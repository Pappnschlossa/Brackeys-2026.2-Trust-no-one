extends Control

var item_id : String = "DICE"
var old_y : int

func _ready() -> void:
	var mat = $Texture.material
	$Texture.material = mat.duplicate()
	old_y = position.y
	position.y = -1080
	spawn_item()

func _on_button_mouse_entered() -> void:
	$Texture.material.set_shader_parameter("width", 2.0)

func _on_button_mouse_exited() -> void:
	$Texture.material.set_shader_parameter("width", 0.0)

func spawn_item() -> void:
	$Texture.texture = g.ITEMS[item_id].texture
	var tween = create_tween()
	tween.tween_property(
		self,
		"position",
		Vector2(position.x, old_y),
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_button_pressed() -> void:
	if g.can_use_item(item_id):
		pass
