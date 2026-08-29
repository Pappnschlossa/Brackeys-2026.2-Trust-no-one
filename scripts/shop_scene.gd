extends Control

signal change_scene
signal add_scene_as_an_overlay
signal shake_screen
signal magnifying_glass_used

@export var left_ui : Control
@export var door_node : Control
@export var shop_item_0 : Control
@export var shop_item_1 : Control
@export var shop_item_2 : Control
@export var shop_item_3 : Control
@onready var shop_items : Array[Control] = [shop_item_0, shop_item_1, shop_item_2, shop_item_3]
@export var envelope_overlay : Control
@export var backgrounds_20 : Node2D
@export var backgrounds_40 : Node2D
@export var backgrounds_50 : Node2D


var using_envelope : bool = false

func _ready() -> void:
	if g.level <= 20:
		backgrounds_20.show()
		backgrounds_40.hide()
		backgrounds_50.hide()
	elif g.level < 40:
		backgrounds_20.hide()
		backgrounds_40.show()
		backgrounds_50.hide()
	else:
		backgrounds_20.hide()
		backgrounds_40.hide()
		backgrounds_50.show()
	randomize_items()
	for item in shop_items:
		item.item_bought.connect(left_ui._on_item_bought)
	magnifying_glass_used.connect(left_ui._on_item_bought)
	left_ui._on_inventory_reload()

func randomize_items() -> void:
	var available_items = g.ITEMS.keys()
	for item in shop_items:
		var chosen_item_id: String = available_items.pick_random()
		available_items.erase(chosen_item_id)
		item.update_item(chosen_item_id)

func _on_shop_exit_button_pressed() -> void:
	g.level += 1
	change_scene.emit("level_scene", "bubble_transition")


func _on_shop_exit_button_mouse_entered() -> void:
	door_node.get_node("Texture").material.set_shader_parameter("width", 5.0)


func _on_shop_exit_button_mouse_exited() -> void:
	door_node.get_node("Texture").material.set_shader_parameter("width", 0.0)

func use_item(item_id : String) -> void:
	match item_id:
		"DICE":
			await get_tree().create_timer(0.6).timeout
			shake_screen.emit()
			await get_tree().create_timer(0.1).timeout
			change_scene.emit("shop_scene")
		"ENVELOPE":
			var item_to_be_found : bool = false
			for item in shop_items:
				if item.price != -1:
					item_to_be_found = true
			if !item_to_be_found: # Avoid using envelope if there is no object to buy
				return
			var target_modulate = envelope_overlay.modulate
			target_modulate.a = 1.0
			envelope_overlay.modulate.a = 0.0
			envelope_overlay.show()
			var tween = create_tween()
			tween.tween_property(
				envelope_overlay,
				"modulate",
				target_modulate,
				0.3
			)
			using_envelope = true
		"KEY":
			await get_tree().create_timer(0.6).timeout
			g.level += 1
			change_scene.emit("level_scene", "bubble_transition")
		"LIFE_POTION":
			pass
		"MAGNIFYING_GLASS":
			var available_items = g.ITEMS.keys()
			available_items.erase("MAGNIFYING_GLASS")
			magnifying_glass_used.emit(available_items.pick_random())
