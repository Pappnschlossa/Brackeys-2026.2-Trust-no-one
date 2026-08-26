extends Control

var item_id : String = "DICE"
var price : int = 99

func _ready() -> void:
	var mat = $Texture.material
	$Texture.material = mat.duplicate()

func update_item(item_id : String) -> void:
	$Texture.texture = g.ITEMS[item_id].texture
	price = int(randf_range(0.7, 1.3)*g.ITEMS[item_id].average_price)
	$PriceTag/RichTextLabel.text = "%s G" % str(price)

func _on_button_mouse_entered() -> void:
	$Texture.material.set_shader_parameter("width", 2.0)

func _on_button_mouse_exited() -> void:
	$Texture.material.set_shader_parameter("width", 0.0)
