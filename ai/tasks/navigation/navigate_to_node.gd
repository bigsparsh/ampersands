@tool
extends BTAction

@export var speed: float = 300.0
@export var target_node_var: StringName = &"target_node"

var actor: FlyingAgentBase:
	get: return agent as FlyingAgentBase

func _generate_name() -> String:
	return "Navigate to position of node stored in [%s] variable with [%s] speed" % [
		target_node_var, speed
	]

func _tick(_delta: float) -> Status:
	var target_node: Node2D = blackboard.get_var(target_node_var, null)
	if not is_instance_valid(target_node):
		return FAILURE
	if actor == null:
		return FAILURE
	var target_pos := target_node.global_position

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
