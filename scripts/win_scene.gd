extends Control

signal change_scene
signal add_scene_as_an_overlay

func _ready() -> void:
	$DialogBox/CollectedText.text = "[font_size=50]	[/font_size]\n[font_size=23]You collected %s coins out of 223 during this run![/font_size]" % g.total_coins_collected
