class_name FlyingAgentBase
extends AgentBase

enum NavResult { RUNNING, DONE, FAILED }

@onready var agent: NavigationAgent2D = %NavigationAgent2D

@export var reach_threshold: Vector2 = Vector2(50.0, 50.0)

var _last_target: Vector2 = Vector2.INF
var _last_speed: float = -1.0
var _stopped: bool = false

func _ready() -> void:
	if not agent.velocity_computed.is_connected(_on_navigation_agent_velocity_computed):
		agent.velocity_computed.connect(_on_navigation_agent_velocity_computed)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func move(p_velocity: Vector2) -> void:
	velocity = p_velocity

func stop_nav_agent() -> void:
	_stopped = true
	agent.target_position = global_position
	_last_target = Vector2.INF  # force re-target on next navigate()

	if agent.avoidance_enabled:
		agent.velocity = Vector2.ZERO  # feed zero into avoidance too


func stop_movement(x: bool = true, y: bool = true) -> void:
	stop_nav_agent()
	var v := velocity
	if x: v.x = 0.0
	if y: v.y = 0.0
	velocity = v

func is_reachable(target_pos: Vector2):
	agent.target_position = target_pos
	agent.get_next_path_position()
	await get_tree().physics_frame
	return agent.is_target_reachable()

func navigate(target_pos: Vector2, speed: float) -> NavResult:
	_stopped = false
	if speed <= 0.0:
		move(Vector2.ZERO)
		return NavResult.FAILED

	if target_pos != _last_target:
		agent.target_position = target_pos
		_last_target = target_pos
	if speed != _last_speed:
		agent.max_speed = speed
		_last_speed = speed

	# Wait for the nav map to be synchronized
	if NavigationServer2D.map_get_iteration_id(agent.get_navigation_map()) == 0:
		return NavResult.RUNNING

	var disp := global_position - target_pos
	if agent.is_navigation_finished() or (abs(disp) < abs(reach_threshold)):
		return NavResult.DONE

	var next_pos: Vector2 = agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_pos) * speed

	if agent.avoidance_enabled:
		agent.velocity = new_velocity  # triggers velocity_computed
	else:
		_on_navigation_agent_velocity_computed(new_velocity)
	return NavResult.RUNNING

func _on_navigation_agent_velocity_computed(safe_velocity: Vector2) -> void:
	if _stopped:
		return
	move(safe_velocity)
