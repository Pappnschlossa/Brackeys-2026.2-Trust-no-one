extends RichTextLabel

@export var check_box : CheckBox

func _ready() -> void:
	text = tr("Tutorial at\nthe start enabled")

func _on_check_box_pressed() -> void:
	if check_box.button_pressed:
		text = tr("Tutorial at\nthe start enabled")
	else:
		text = tr("Tutorial at\nthe start disabled")
