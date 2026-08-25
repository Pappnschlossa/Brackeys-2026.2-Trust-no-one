extends Control

@export var numbers_hiding_text : RichTextLabel # TEMP
@export var money_text : RichTextLabel

func _ready() -> void:
	money_text.text = "Money: %s" % str(g.money)
	update_health()

func update_hidden_numbers() -> void:
	var strings_array : Array[String] = []
	for n in g.get_array_of_numbers_in_use_without_multiplicity():
		strings_array.append("%s%s: " % ["\n", str(n)])
		strings_array.append(str(g.number_occurences[n]))
	while len(strings_array) < 12:
		strings_array.append("")
	numbers_hiding_text.text = "Numbers Hiding : %s%s%s%s%s%s%s%s%s%s%s%s" % strings_array

func update_health() -> void:
	if g.lives == 3:
		get_node("%FullHeart0").visible = true
		get_node("%FullHeart1").visible = true
		get_node("%FullHeart2").visible = true
	elif g.lives == 2:
		get_node("%FullHeart0").visible = true
		get_node("%FullHeart1").visible = true
		get_node("%FullHeart2").visible = false
	elif g.lives == 1:
		get_node("%FullHeart0").visible = true
		get_node("%FullHeart1").visible = false
		get_node("%FullHeart2").visible = false
	else:
		get_node("%FullHeart0").visible = false
		get_node("%FullHeart1").visible = false
		get_node("%FullHeart2").visible = false
	get_node("%EmptyHeart0").visible = !get_node("%FullHeart0").visible
	get_node("%EmptyHeart1").visible = !get_node("%FullHeart1").visible
	get_node("%EmptyHeart2").visible = !get_node("%FullHeart2").visible
