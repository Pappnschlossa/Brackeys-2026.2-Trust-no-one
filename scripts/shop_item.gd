extends Control

signal item_bought

var item_id : String = "DICE"
var price : int = 99

func _ready() -> void:
	var mat = $Texture.material
	$Texture.material = mat.duplicate()

func update_item(new_item_id : String) -> void:
	item_id = new_item_id
	$Texture.texture = g.ITEMS[item_id].texture
	price = int(randf_range(0.7, 1.3)*g.ITEMS[item_id].average_price)
	$PriceTag/Text.text = "%s G" % str(price)

func _on_button_mouse_entered() -> void:
	$Texture.material.set_shader_parameter("width", 2.0)

func _on_button_mouse_exited() -> void:
	$Texture.material.set_shader_parameter("width", 0.0)

func _on_button_pressed() -> void:
	if g.can_buy_item(price):
		g.money -= price
		$PriceTag/Text.text = "Sold"
		# We animate it
		var tween = create_tween()
		tween.tween_property(
			$Texture,
			"position",
			Vector2($Texture.position.x, -1080),
			1.0
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		item_bought.emit(item_id)
