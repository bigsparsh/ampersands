extends LimboState

var buffer_timer: int

func _enter() -> void:
	print("FALL")
	agent.sprite.play("fall")
	agent.gravity_multiplier = 1.5
	
func _update(delta: float) -> void:
	buffer_timer -= delta
	if Input.is_action_just_pressed("jump"):
		if blackboard.get_var(&"can_double_jump"):
			blackboard.set_var(&"can_double_jump", false)
			dispatch("to_jump")
			return
		buffer_timer = agent.jump_buffer_time
		
	if Input.is_action_just_pressed("dash"):
		dispatch("to_dash")
		return
	if agent.is_on_floor():
		if buffer_timer > 0:
			dispatch("to_jump")
			return
		dispatch("to_idle")
		return
	agent.velocity.x = agent.jump_speed.x * agent.direction

func _exit() -> void:
	agent.gravity_multiplier = 1
