extends Control

signal change_scene
signal add_scene_as_an_overlay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_shop_exit_door_pressed() -> void:
	change_scene.emit("level_scene")
