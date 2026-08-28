extends Control

@export var numbers_hiding_text : RichTextLabel # TEMP
@export var money_text : RichTextLabel
@export var item_slot_0 : TextureRect
@export var item_slot_1 : TextureRect
@export var item_slot_2 : TextureRect
@export var item_slot_3 : TextureRect
@onready var item_slots : Array[TextureRect] = [item_slot_0, item_slot_1, item_slot_2, item_slot_3]
@export var numbers_container : Control
@export var center : Marker2D
@export var level : Control

var money_text_previous_value : int
var money_to_display
var angle : float = 0.0
var radius : int = 75
@export var speed : float = 1.0
var numbers_in_use : Array[int] = g.get_array_of_numbers_in_use_without_multiplicity()
var in_level : bool = false

func _ready() -> void:
	money_text.text = "Money: %s" % str(g.money)
	money_text_previous_value = g.money
	update_health()
	
func _process(delta: float) -> void:
	if !in_level or false:
		return
	angle += speed*delta
	var i : int = 0
	for number in numbers_in_use:
		var number_node = numbers_container.get_child(2 + i)
		if number != 1:
			var a : float = angle + i*TAU/(len(numbers_in_use)-1)
			number_node.position = center.position + radius*Vector2(cos(a), sin(a))
			i += 1

func entered_level() -> void:
	in_level = true

func update_hidden_numbers() -> void:
	numbers_in_use = g.get_array_of_numbers_in_use_without_multiplicity()
	var radian_step : float = TAU/(len(numbers_in_use)-1)
	var strings_array : Array[String] = []
	var i : int = 0
	if 0 in numbers_in_use:
		numbers_in_use[0] = 1
		numbers_in_use[1] = 0
	for n in numbers_in_use:
		strings_array.append("%s%s: " % ["\n", str(n)])
		strings_array.append(str(g.number_occurences[n]))
		var instance = load("uid://bwx6t2ov5vy14").instantiate()
		instance.number = n
		instance.position = center.position
		if n != 1:
			instance.position += radius*Vector2(cos(radian_step*i), sin(radian_step*i))
			i += 1
		numbers_container.add_child(instance)
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
			instance.item_effect.connect(level.use_item)
			instance.item_effect.connect(use_item)
			instance.just_bought = true
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

func _on_inventory_reload() -> void:
	for i in range(g.MAX_ITEM_AMOUNT):
		if g.current_items[i] == "EMPTY":
			continue
		var item = load("uid://ces2bhel05kdm")
		var instance = item.instantiate()
		instance.item_id = g.current_items[i]
		instance.item_pos = i
		instance.item_effect.connect(level.use_item)
		instance.item_effect.connect(use_item)
		item_slots[i].add_child(instance)

func use_item(item_id : String) -> void:
	match item_id:
		"DICE":
			pass
		"ENVELOPE":
			pass
		"KEY":
			pass
		"LIFE_POTION":
			g.lives = min(g.lives + 1, 3)
			update_health()
		"MAGNIFYING_GLASS":
			pass
		
