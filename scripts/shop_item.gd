extends Control

signal item_bought

@export var shop : Control

var item_id : String = "DICE"
var price : int = 99
var tween_processing : bool = false

func _ready() -> void:
	var mat = $Texture.material
	$Texture.material = mat.duplicate()

func update_item(new_item_id : String) -> void:
	item_id = new_item_id
	if g.level != 40:
		$Texture.texture = g.ITEMS[item_id].texture
		price = int(randf_range(0.7, 1.3)*g.ITEMS[item_id].average_price)
	else:
		$Texture.texture = g.ORBS[item_id].texture
		price = int(randf_range(0.9, 1.1)*g.ORBS[item_id].average_price)
	$PriceTag/Text.text = "%s G" % str(price)

func _on_button_mouse_entered() -> void:
	$Texture.material.set_shader_parameter("width", 2.0)

func _on_button_mouse_exited() -> void:
	$Texture.material.set_shader_parameter("width", 0.0)

func _on_button_pressed() -> void:
	if tween_processing:
		return
	if shop.using_envelope:
		var old_price : int = price
		while price == old_price:
			price = max(1, int(randf_range(0.2, 1.0)*g.ITEMS[item_id].average_price))
			$PriceTag/Text.text = "%s G" % str(price)
		if randf() < 0.1:
			price = 1
			$PriceTag/Text.text = "99 G?"
		shop.using_envelope = false
		var target_modulate = shop.envelope_overlay.modulate
		target_modulate.a = 0.0
		shop.envelope_overlay.modulate.a = 1.0
		shop.envelope_overlay.show()
		var tween = create_tween()
		tween.tween_property(
			shop.envelope_overlay,
			"modulate",
			target_modulate,
			0.3
		)
		await tween.finished
		shop.envelope_overlay.visible = false
		
	elif (g.level != 40 and g.can_buy_item(price)) or (g.level == 40 and g.can_buy_orb(price)):
		g.money -= price
		if g.level != 40:
			g.nb_of_items_being_bought += 1
		else:
			g.nb_of_orbs_being_bought += 1
		price = -1
		$PriceTag/Text.text = "Sold"
		# We animate it
		var tween = create_tween()
		tween.tween_property(
			$Texture,
			"position",
			Vector2($Texture.position.x, -1080),
			0.6
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		get_node("SFX").play()
		tween_processing = true
		await tween.finished
		tween_processing = false
		item_bought.emit(item_id)
		if g.level != 40:
			g.nb_of_items_being_bought -= 1
		else:
			g.nb_of_orbs_being_bought -= 1
