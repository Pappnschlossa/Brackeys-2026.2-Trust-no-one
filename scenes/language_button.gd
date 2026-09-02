extends Button

@export var check_box_text : RichTextLabel

func _ready() -> void:
	text = "  %s  " % TranslationServer.get_locale()

func _on_pressed() -> void:
	var next_language = (g.current_language_id + 1) % len(g.languages)
	g.current_language_id = next_language
	TranslationServer.set_locale(g.languages[next_language])
	text = "  %s  " % g.languages[next_language]
	g.update_directions_language()
	check_box_text._on_check_box_pressed()
