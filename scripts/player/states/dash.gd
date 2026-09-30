extends LimboState

var dash_timer: float
var debug_point_gap: float = 0.025
var point_timer: float
var debug_point: Vector2

func _enter() -> void:
	print("DASH")
	if not blackboard.get_var(&"can_dash"):
		dispatch("to_fall")
		return
	var prev_state = agent.hsm.get_previous_active_state().name
	if prev_state in ['Fall', 'Jump']:
		blackboard.set_var(&"can_dash", false)
	#agent.sprite.play("dash")
	
	point_timer = 0
	debug_point = agent.position
	agent.gravity_multiplier = 0
	agent.velocity.y = 0
	agent.velocity.x = agent.dash_speed * (-1 if agent.facing else 1)
	dash_timer = agent.dash_time
	
	blackboard.set_var(&"can_dash", false)

func _update(delta: float) -> void:
	dash_timer -= delta
	point_timer += delta
	# Add debug points for parabola visual
	if point_timer > debug_point_gap:
		point_timer = 0
		DebugDraw.instance.create_two_point_dyanmic_path(debug_point, agent.position, Color.YELLOW)
		debug_point = agent.position
	if dash_timer < 0:
		dispatch("to_fall")
		return

func _exit() -> void:
	DebugDraw.instance.create_two_point_dyanmic_path(debug_point, agent.position, Color.YELLOW)

	agent.gravity_multiplier = 1
