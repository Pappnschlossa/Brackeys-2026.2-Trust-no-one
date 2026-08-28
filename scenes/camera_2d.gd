extends Camera2D

@export var randomStrength : float = 50.0
@export var shakeFade : float = 3.0

var rng = RandomNumberGenerator.new()

var shake_strength : float = 0.0

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		offset = randomOffset()

func apply_shake() -> void:
	shake_strength = randomStrength

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
