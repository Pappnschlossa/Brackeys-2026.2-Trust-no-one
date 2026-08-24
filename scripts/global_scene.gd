extends Node

@export var music_node : Node
@export var canvas_layer : CanvasLayer
@export var transition_rect : ColorRect
@export var gear_fade_in_duration = 3.0
@export var gear_fade_out_duration = 3.0
@export var wipe_fade_in_duration = 0.3
@export var wipe_fade_out_duration = 0.3

const SCENES = {
	"title_scene" : "uid://bv0o1kuyl8te6",
	"level_scene" : "uid://cfpx4aji2a1nu",
	"shop_scene" : "uid://bswonif37ehh8",
	"numpad_overlay" : "uid://cdtr5twexbdo3"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	g.reinitialize()
	_on_change_scene("title_scene", null)
	

func _on_change_scene(scene_name, transition_type):
	var scene = load(SCENES[scene_name])
	var instance = scene.instantiate()
	
	#await transition_in(transition_type)

	for child in get_children():
		if child != transition_rect and child != canvas_layer:
			remove_child(child)
	instance.change_scene.connect(_on_change_scene)
	instance.add_scene_as_an_overlay.connect(_on_add_scene_as_an_overlay)
	add_child(instance)
	move_child(instance, 0)
	
	#move_child(canvas_layer, 2)

	#transition_out(transition_type)
	
	#music_node._ready()
	

func _on_add_scene_as_an_overlay(scene_name, pos = Vector2(0, 0)):
	var scene = load(SCENES[scene_name])
	var instance = scene.instantiate()
	instance.position = pos
	instance.change_scene.connect(_on_change_scene)
	instance.add_scene_as_an_overlay.connect(_on_add_scene_as_an_overlay)
	instance.remove_overlay.connect(_on_remove_overlay)
	
	if scene_name == "numpad_overlay":
		instance.numpad_button_pressed.connect(get_node("Level")._on_numpad_button_pressed)
	
	## Animation
	#instance.position.y = 1080
	#var tween = create_tween()
	#tween.tween_property(
			#instance,
			#"position",
			#Vector2(0, 0),
			#wipe_fade_in_duration
		#).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	add_child(instance)
	move_child(instance, 1)
	#move_child(canvas_layer, 2)
	
	#music_node._ready()

func _on_remove_overlay():
	var overlay = get_children()[1]
	## Animation
	#var tween = create_tween()
	#tween.tween_property(
			#overlay,
			#"position",
			#Vector2(0, 1080),
			#wipe_fade_in_duration
		#).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	#await tween.finished
	remove_child(overlay)
