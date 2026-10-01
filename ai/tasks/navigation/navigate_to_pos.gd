@tool
extends BTAction

@export var speed: float = 300.0
@export var target_pos_var: StringName = &"target_pos"

var actor: FlyingAgentBase:
	get: return agent as FlyingAgentBase

func _generate_name() -> String:
	return "Navigate to position stored in [%s] variable with [%s] speed" % [
		target_pos_var, speed
	]

func _tick(_delta: float) -> Status:
	var target_pos: Vector2 = blackboard.get_var(target_pos_var, Vector2.INF)
	if target_pos == Vector2.INF:
		return FAILURE

	match actor.navigate(target_pos, speed):
		FlyingAgentBase.NavResult.DONE:
			return SUCCESS
		FlyingAgentBase.NavResult.FAILED:
			return FAILURE
		_:
			return RUNNING

func _exit() -> void:
	if actor != null:
		actor.stop_movement()
