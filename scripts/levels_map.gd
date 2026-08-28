extends Control


func _ready() -> void:
	get_node("VBox/Text").text = "Level %s" % str(g.level) # Temp
	get_node("MapCursor").position.y = g.level*(1080-128)/50
