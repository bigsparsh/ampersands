extends LimboState

var dash_timer: float

func _enter() -> void:
	print("DASH")
	if not blackboard.get_var(&"can_dash"):
		dispatch("to_fall")
		return
	var prev_state = agent.hsm.get_previous_active_state().name
	if prev_state in ['Fall', 'Jump']:
		blackboard.set_var(&"can_dash", false)
	agent.sprite.play("dash")
	agent.gravity_multiplier = 0
	agent.velocity.y = 0
	agent.velocity.x = agent.dash_speed * (-1 if agent.facing else 1)
	dash_timer = agent.dash_time
	
	blackboard.set_var(&"can_dash", false)

func _update(delta: float) -> void:
	dash_timer -= delta
	if dash_timer < 0:
		dispatch("to_fall")
		return
