extends Control

@export var numbers_hiding_text : RichTextLabel # TEMP
@export var money_text : RichTextLabel
@export var item_slot_0 : TextureRect
@export var item_slot_1 : TextureRect
@export var item_slot_2 : TextureRect
@export var item_slot_3 : TextureRect
@onready var item_slots : Array[TextureRect] = [item_slot_0, item_slot_1, item_slot_2, item_slot_3]

var money_text_previous_value : int
var money_to_display

func _ready() -> void:
	money_text.text = "Money: %s" % str(g.money)
	money_text_previous_value = g.money
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

func _on_item_bought(item_id : String) -> void:
	# Add item
	for i in range(g.MAX_ITEM_AMOUNT):
		if g.current_items[i] == "EMPTY":
			g.current_items[i] = item_id
			var item = load("uid://ces2bhel05kdm")
			var instance = item.instantiate()
			instance.item_id = item_id
			instance.item_pos = i
			item_slots[i].add_child(instance)
			break
	# Update Money
	money_to_display = money_text_previous_value
	var tween = create_tween()
	tween.tween_method(
		func(value):
			money_to_display = value
			money_text.text = "Money: %s" % str(value),
		money_to_display,
		g.money,
		sqrt(money_text_previous_value-g.money)/4
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	money_text_previous_value = g.money
