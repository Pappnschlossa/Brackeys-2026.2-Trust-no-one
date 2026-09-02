extends Control


func _ready() -> void:
	if g.level >= 10:
		get_node("MapFirstPath").hide()
		get_node("MapPath").show()
		get_node("Text").text = tr("Floor %s") % str(g.level)
		get_node("MapCursor").position.y = g.level*(1080-128)/50
	else:
		get_node("MapFirstPath").show()
		get_node("MapPath").hide()
		get_node("Text").text = tr("Floor %s") % str(g.level)
		get_node("MapCursor").position.y = g.level*(1080-128)/10
