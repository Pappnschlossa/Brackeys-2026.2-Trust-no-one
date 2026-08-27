extends Control

var item_id : String = "DICE"
var old_y : int
var item_pos : int
var used : bool = false

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
	if !used:
		if g.can_use_item(item_id):
			used = true
			$Texture.material = load("uid://dq0inc3vsfdav").duplicate()
			var local_pos = $Texture.get_local_mouse_position()
			var uv = get_uv_from_click(local_pos)
			burnCard(uv)
			g.current_items[item_pos] = "EMPTY"
			match item_id:
				"DICE" :
					pass
				"ENVELOPE" :
					pass
				"KEY" :
					pass
				"LIFE_POTION" :
					pass
				"MAGNIFYING_GLASS" :
					pass

func get_uv_from_click(local_click_pos: Vector2) -> Vector2:
	var top_left_pos = local_click_pos
	var uv = top_left_pos / ($Texture.size)
	return uv

func burnCard(uv):
	if $Texture.material and $Texture.material is ShaderMaterial:
		var tween = create_tween()
		# set the uvs in the shader
		$Texture.material.set_shader_parameter("position", uv)
		# use tweens to animate the radius value
		tween.tween_method(update_radius, 0.0, 2.0, 1.5)
	 
func update_radius(value: float):
	$Texture.material.set_shader_parameter("radius", value)
