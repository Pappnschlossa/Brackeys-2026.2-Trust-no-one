extends Control

@export var numbers_hiding_text : RichTextLabel # TEMP
@export var money_text : RichTextLabel

func _ready() -> void:
	money_text.text = "Money: %s" % str(g.money)

func update_hidden_numbers() -> void:
	var strings_array : Array[String] = []
	for n in g.get_array_of_numbers_in_use_without_multiplicity():
		strings_array.append("%s%s: " % ["\n", str(n)])
		strings_array.append(str(g.number_occurences[n]))
	while len(strings_array) < 12:
		strings_array.append("")
	numbers_hiding_text.text = "Numbers Hiding : %s%s%s%s%s%s%s%s%s%s%s%s" % strings_array
