extends Control


func _ready() -> void:
	get_node("VBox/Text").text = "  Floor %s" % str(g.level)
	get_node("MapCursor").position.y = g.level*(1080-128)/50
