extends RichTextLabel


func _ready() -> void:
	text = "Seed: %s" % str(g.level_rng.seed)
