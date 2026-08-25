extends Control


func _ready() -> void:
	get_node("VBox/Text").text = "Level %s" % str(g.level) # Temp
