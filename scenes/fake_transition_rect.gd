extends ColorRect


func fake_transition() -> void:
	material = load("uid://bmp2oqi20jmk5").duplicate()
	var gradient_texture : GradientTexture2D = material.get_shader_parameter("gradient_texture")
	gradient_texture.fill_to = Vector2(-0.5, -1.0)
	var tween_in = create_tween()
	show()
	tween_in.tween_property(
		gradient_texture,
		"fill_to",
		Vector2(0.505, 0.5),
		1.5
	).set_ease(Tween.EASE_OUT)
	await tween_in.finished
	
	await get_tree().create_timer(1.0).timeout
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("scratch")
	g.lives -= 1
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.hide()
	fake_transition_out()

func fake_transition_out() -> void:
	await get_tree().create_timer(1.0).timeout
	$ColorRect.modulate.a = 1.0
	$ColorRect.show()
	var gradient_texture : GradientTexture2D = material.get_shader_parameter("gradient_texture")
	gradient_texture.fill_to = Vector2(-0.5, -1.0)
	var target_modulate = $ColorRect.modulate
	target_modulate.a = 0.0
	var tween_out = create_tween()
	tween_out.tween_property(
		$ColorRect,
		"modulate",
		target_modulate,
		2.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween_out.finished
	$ColorRect.hide()
	hide()
