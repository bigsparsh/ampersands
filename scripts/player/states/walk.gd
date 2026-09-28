extends LimboState

func _enter() -> void:
	print("WALK")
	agent.sprite.play("walk")
	blackboard.set_var(&"can_double_jump", true)
	blackboard.set_var(&"can_dash", true)

	
func _update(delta: float) -> void:
	if not agent.direction: 
		dispatch("to_idle")
		return
	if not agent.is_on_floor():
		dispatch("to_fall")
		return
	if Input.is_action_just_pressed("jump"):
		dispatch("to_jump")
		return
	if Input.is_action_just_pressed("dash"):
		dispatch("to_dash")
		return
	agent.velocity.x = agent.walk_speed * agent.direction
