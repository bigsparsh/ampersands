extends LimboState


func _enter() -> void:
	print("IDLE")
	#agent.sprite.play("idle")
	blackboard.set_var(&"can_double_jump", true)
	blackboard.set_var(&"can_dash", true)
	agent.velocity = Vector2.ZERO


func _update(_delta: float) -> void:
	if Input.is_action_pressed("up"):
		dispatch("to_hurt")
		return
	if agent.direction:
		dispatch("to_walk")
		return
	if Input.is_action_just_pressed("jump"):
		dispatch("to_jump")
		return
	if Input.is_action_just_pressed("dash"):
		dispatch("to_dash")
		return
