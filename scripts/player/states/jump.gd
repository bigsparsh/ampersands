extends LimboState

func _enter() -> void:
	print("JUMP")
	agent.sprite.play("jump")
	agent.add_tick(Color.ORANGE_RED)
	agent.gravity_multiplier = 1.5 - (1.0 if agent.hsm.get_previous_active_state().name == "Jump" else 0)
	agent.velocity.y = agent.jump_speed.y * \
	(100 if agent.hsm.get_previous_active_state().name == "Jump" else 1)
	
func _update(delta: float) -> void:
	if agent.velocity.y > 0:
		dispatch("to_fall")
		return
	if Input.is_action_just_pressed("dash"):
		dispatch("to_dash")
		return
	if agent.velocity.y > -60.0:
		agent.gravity_multiplier = 0.45
	if Input.is_action_just_released("jump") or not Input.is_action_pressed("jump"):
		agent.velocity.y *= 0
		dispatch("to_fall")
		return
	agent.velocity.x = agent.jump_speed.x * agent.direction
	
func _exit() -> void:
	agent.gravity_multiplier = 1
