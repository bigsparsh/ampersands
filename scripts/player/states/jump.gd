extends LimboState

@export var gravity_boost: float = 2.0
var debug_point_gap: float = 0.025
var point_timer: float
var debug_point: Vector2

func _enter() -> void:
	print("JUMP")
	#agent.sprite.play("jump")

	point_timer = 0
	debug_point = agent.position
	DebugDraw.instance.add_tick(agent.position, Color.GREEN_YELLOW)
	
	agent.gravity_multiplier *= gravity_boost
	agent.velocity.y = agent.jump_speed.y
	
func _update(delta: float) -> void:
	point_timer += delta
	
	# Add debug points for parabola visual
	if point_timer > debug_point_gap:
		point_timer = 0
		DebugDraw.instance.create_two_point_dyanmic_path(debug_point, agent.position, Color.RED)
		debug_point = agent.position
	
	var prev_state = agent.hsm.get_previous_active_state().name
	if prev_state == "Fall" and not Input.is_action_pressed("jump"):
		agent.velocity.y *= 0.15
		
	if Input.is_action_just_released("jump"):
		agent.velocity.y *= 0
		dispatch("to_fall")
		return
	
	if agent.velocity.y > 0:
		dispatch("to_fall")
		return
	
	if Input.is_action_just_pressed("dash"):
		dispatch("to_dash")
		return
	
	# Air hang 
	if agent.velocity.y > -60.0:
		agent.gravity_multiplier = clamp(agent.gravity_multiplier * 0.65, 1.0, 99)
	
	agent.velocity.x = agent.jump_speed.x * agent.direction
	
func _exit() -> void:
	DebugDraw.instance.create_two_point_dyanmic_path(debug_point, agent.position, Color.RED)
	agent.gravity_multiplier = 1.0
