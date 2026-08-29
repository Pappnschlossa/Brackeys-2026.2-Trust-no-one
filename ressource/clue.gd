extends Resource
class_name Clue

var is_text : bool = false
var text : String
var is_equation : bool

# Boolean clue variables (if !is_equation)
var target : int
var value : int # -2 for even, -1 for odd and 0 to 10 for number

# Equation clue variables (if is_equation)
var equation_targets : Array[int] # Array of 2 integers corresponding to Y and Z
var operator : String # "plus", "minus" or "mult"
