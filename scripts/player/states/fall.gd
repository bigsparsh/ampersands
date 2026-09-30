extends LimboState

@export var gravity_boost: float = 2.5
var buffer_timer: float
var debug_point_gap: float = 0.025
var point_timer: float
var debug_point: Vector2

func _enter() -> void:
	print("FALL")
	#agent.sprite.play("fall")
	point_timer = 0
	debug_point = agent.position
	DebugDraw.instance.add_tick(agent.position, Color.GREEN)

	agent.gravity_multiplier *= gravity_boost
	
func _update(delta: float) -> void:
	buffer_timer -= delta
	point_timer += delta
	
	# Add debug points for parabola visual
	if point_timer > debug_point_gap:
		point_timer = 0
		DebugDraw.instance.create_two_point_dyanmic_path(debug_point, agent.position, Color.GREEN)
		debug_point = agent.position
	
	# Input buffer timer reset and double jump
	if Input.is_action_just_pressed("jump"):
		#if blackboard.get_var(&"can_double_jump"):
			#blackboard.set_var(&"can_double_jump", false)
			#dispatch("to_jump")
			#return
		DebugDraw.instance.add_tick(agent.position, Color.DARK_RED)
		
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
	DebugDraw.instance.add_tick(agent.position, Color.TOMATO)
	DebugDraw.instance.create_two_point_dyanmic_path(debug_point, agent.position, Color.GREEN)

	agent.gravity_multiplier = 1.0
