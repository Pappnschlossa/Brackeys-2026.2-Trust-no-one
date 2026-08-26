extends Control

signal change_scene
signal add_scene_as_an_overlay

@export var left_ui : Control
@export var door_node : Control
@export var shop_item_0 : Control
@export var shop_item_1 : Control
@export var shop_item_2 : Control
@export var shop_item_3 : Control
@onready var shop_items : Array[Control] = [shop_item_0, shop_item_1, shop_item_2, shop_item_3]

func _ready() -> void:
	randomize_items()
	for item in shop_items:
		item.item_bought.connect(left_ui._on_item_bought)

func randomize_items() -> void:
	var available_items = g.ITEMS.keys()
	for item in shop_items:
		var chosen_item_id: String = available_items.pick_random()
		available_items.erase(chosen_item_id)
		item.update_item(chosen_item_id)

func _on_shop_exit_button_pressed() -> void:
	change_scene.emit("level_scene")


func _on_shop_exit_button_mouse_entered() -> void:
	door_node.get_node("Texture").material.set_shader_parameter("width", 5.0)


func _on_shop_exit_button_mouse_exited() -> void:
	door_node.get_node("Texture").material.set_shader_parameter("width", 0.0)
