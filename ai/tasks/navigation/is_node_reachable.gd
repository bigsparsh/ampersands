@tool
extends BTCondition

@export var target_node_var: StringName = &"target_node"

var actor: FlyingAgentBase:
	get: return agent as FlyingAgentBase

func _generate_name() -> String:
	return "Is the node stored in [%s] reachable?" % [
		target_node_var
	]

func _tick(_delta: float) -> Status:
	var target_node: Node2D = blackboard.get_var(target_node_var, null)
	if not is_instance_valid(target_node):
		return FAILURE
	if actor == null:
		return FAILURE
	var target_pos := target_node.global_position
	if target_pos == Vector2.INF:
		return FAILURE

	if  await actor.is_reachable(target_pos):
		return SUCCESS
	return FAILURE
