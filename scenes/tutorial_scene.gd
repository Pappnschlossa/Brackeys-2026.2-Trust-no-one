extends Control

signal change_scene
signal add_scene_as_an_overlay
signal remove_overlay

@export var previous_button : TextureButton
@export var next_button : TextureButton
@export var step_nb_text : RichTextLabel
@export var text_1 : RichTextLabel
@export var text_2 : RichTextLabel
@export var text_3 : RichTextLabel
@export var text_4 : RichTextLabel
@export var text_5 : RichTextLabel
@onready var texts = [text_1, text_2, text_3, text_4, text_5]
@export var continue_button : Button
@export var text_box : MarginContainer
@onready var center_position : Vector2 = text_box.position
@export var overlay : ColorRect

var step : int = 1
const max_step : int = 5


func update_explanation():
	step_nb_text.text = "%s / %s" % [str(step), str(max_step)]
	for i in range(max_step):
		if i == step-1:
			texts[i].visible = true
		else:
			texts[i].visible = false
	match step:
		1:
			text_box.position.y = center_position.y + 150
			overlay.material.set_shader_parameter("hole_rect", Vector4(0.26, 0.0, 0.55, 0.46))
			overlay.material.set_shader_parameter("hole_rect_2", Vector4(0.0, 0.0, 0.0, 0.0))
		2:
			text_box.position.y = center_position.y - 200
			overlay.material.set_shader_parameter("hole_rect", Vector4(0.26, 0.46, 0.55, 0.46))
			overlay.material.set_shader_parameter("hole_rect_2", Vector4(0.0, 0.0, 0.0, 0.0))
		3:
			text_box.position.y = center_position.y - 200
			overlay.material.set_shader_parameter("hole_rect", Vector4(-0.3, -0.1, 0.46, 0.46))
			overlay.material.set_shader_parameter("hole_rect_2", Vector4(0.0, 0.0, 0.0, 0.0))
			#overlay.material.set_shader_parameter("hole_rect_2", Vector4(-0.3, -0.1, 0.47, 0.46))
		4:
			text_box.position.y = center_position.y - 200
			overlay.material.set_shader_parameter("hole_rect", Vector4(0.26, 0.46, 0.55, 0.46))
			overlay.material.set_shader_parameter("hole_rect_2", Vector4(0.0, 0.0, 0.0, 0.0))
		5:
			text_box.position.y = center_position.y
			overlay.material.set_shader_parameter("hole_rect", Vector4(0.0, 0.0, 0.0, 0.0))
			overlay.material.set_shader_parameter("hole_rect_2", Vector4(0.0, 0.0, 0.0, 0.0))
			#overlay.material.set_shader_parameter("hole_rect", Vector4(0.26, 0.0, 0.52, 0.46))
			#overlay.material.set_shader_parameter("hole_rect_2", Vector4(-0.3, -0.1, 0.47, 0.46))

func part_two() -> void:
	

func _ready() -> void:
	update_explanation()


func _on_previous_button_pressed() -> void:
	step = max(step - 1, 1)
	step_nb_text.visible = true
	continue_button.visible = false
	update_explanation()


func _on_next_button_pressed() -> void:
	step = min(step + 1, max_step)
	if step == max_step:
		step_nb_text.visible = false
		continue_button.visible = true
	update_explanation()


func _on_continue_button_pressed() -> void:
	hide()
